#!/usr/bin/env tsx

// @ts-ignore - Using globally installed packages
import { chromium, Page } from "playwright";
// @ts-ignore - Node.js built-in module
import { execSync } from "child_process";

// Types
interface Transaction {
  date: string;
  description: string;
  type: "debit" | "credit";
  amount: string;
}

// Environment variables
const getEnvVar = (name: string): string => {
  const value = process.env[name];
  if (!value) {
    console.error(`Error: ${name} environment variable not set.`);
    process.exit(1);
  }
  return value;
};

const SECU_USERNAME = getEnvVar("SECU_USERNAME");
const SECU_PASSWORD = getEnvVar("SECU_PASSWORD");
const SECU_ACCOUNT_URL = getEnvVar("SECU_ACCOUNT_URL");

// Helper to copy text to clipboard using xsel
const copyToClipboard = (text: string): void => {
  execSync(`echo -n "${text}" | xsel --clipboard --input`);
};

// Helper functions for login flow
const waitForUsernameInput = async (page: Page): Promise<void> => {
  const usernameSelector =
    'input[name="username"], input[id*="username" i], input[type="text"]';
  await page.waitForSelector(usernameSelector, { timeout: 10000 });

  copyToClipboard(SECU_USERNAME);
  console.error(
    "Copied username to clipboard. Please paste it into the username field.",
  );

  await page.waitForFunction(
    (selector) => {
      const input = document.querySelector(selector) as HTMLInputElement;
      return input && input.value.length > 0;
    },
    usernameSelector,
    { timeout: 300000 },
  );
};

const waitForPasswordAndLogin = async (page: Page): Promise<void> => {
  copyToClipboard(SECU_PASSWORD);
  console.error(
    "Copied password to clipboard. Please paste it and complete login.",
  );

  await page.waitForURL("https://memberaccess.ncsecu.org/accounts/overview", {
    timeout: 300000,
    waitUntil: "domcontentloaded",
  });

  console.error("✓ Login successful!\n");
};

// Scrape transactions from the page
const scrapeTransactions = (page: Page): Promise<Transaction[]> =>
  page.evaluate(() => {
    interface TransactionData {
      date: string;
      description: string;
      amount: string;
      type: "debit" | "credit";
    }

    const sections = Array.from(
      document.querySelectorAll(
        ".posted-transactions-list ul.transactionItemList, .pending-transactions-list ul.transactionItemList",
      ),
    );

    return sections.flatMap((section) => {
      // The date header is in a sibling of the parent li.postedGroupListItem
      const parentLi = section.parentElement;
      const headerLi = parentLi?.previousElementSibling as HTMLElement;
      const dateText =
        headerLi
          ?.querySelector("h4.transaction-year-header")
          ?.textContent?.trim() || "";

      const items = Array.from(section.querySelectorAll("li.transaction-item"));

      return items
        .map((item) => {
          const nameEl = item.querySelector(".name");
          const amountEl = item.querySelector("p.amount");

          if (!nameEl || !amountEl) return null;

          return {
            date: dateText,
            description: nameEl.textContent?.trim() || "",
            amount: amountEl.textContent?.trim() || "",
            type: amountEl.classList.contains("credit")
              ? ("credit" as const)
              : ("debit" as const),
          };
        })
        .filter((tx): tx is TransactionData => tx !== null);
    });
  });

// Format a single transaction line
const formatTransaction = (
  tx: Transaction,
  maxDateLength: number,
  maxDescLength: number,
): string => {
  const date = tx.date.padEnd(maxDateLength);
  const description = tx.description.padEnd(maxDescLength);
  const line = `${date}   ${description}   ${tx.amount}`;
  return tx.type === "credit" ? `\x1b[32m${line}\x1b[0m` : line;
};

// Display transactions
const displayTransactions = (transactions: Transaction[]): void => {
  console.error(
    "\n============================================================",
  );
  console.error("===== Transactions =====");
  console.error(
    "============================================================\n",
  );

  if (transactions.length === 0) {
    console.log("No transactions found.");
    return;
  }

  const maxDateLength = Math.max(...transactions.map((tx) => tx.date.length));
  const maxDescLength = Math.max(
    ...transactions.map((tx) => tx.description.length),
  );

  transactions
    .map((tx) => formatTransaction(tx, maxDateLength, maxDescLength))
    .forEach((line) => console.log(line));
};

const main = async (): Promise<void> => {
  console.error("Launching browser...");
  const browser = await chromium.launch({ headless: false });
  const context = await browser.newContext();
  const page = await context.newPage();

  try {
    console.error("Navigating to login page...");
    await page.goto("https://memberaccess.ncsecu.org/pre-auth/login");

    await waitForUsernameInput(page);
    await waitForPasswordAndLogin(page);

    console.error("Navigating to account page...");
    await page.goto(SECU_ACCOUNT_URL);

    console.error("Waiting for transactions to load...");
    await page.waitForSelector("li.transaction-item", { timeout: 30000 });

    // Click "Show more" button if it exists
    const showMoreButton = await page.locator("button.load-more-btn");
    if (await showMoreButton.isVisible()) {
      console.error("Clicking 'Show more' button...");
      const initialCount = await page.locator("li.transaction-item").count();
      await showMoreButton.click();
      // Wait for more transactions to be added to the page
      await page.waitForFunction(
        (initial) => {
          const items = document.querySelectorAll("li.transaction-item");
          return items.length > initial;
        },
        initialCount,
        { timeout: 10000 }
      );
    }

    console.error("Collecting transaction info...");
    const transactions = await scrapeTransactions(page);

    displayTransactions(transactions);
  } finally {
    await browser.close();
  }
};

main().catch((error) => {
  console.error("Error:", error);
  process.exit(1);
});
