---
name: notion-axi
description: "Operate Notion through the notion-axi CLI — search; read, create, update, archive, and move pages; create and edit databases and query/set typed row properties; manage blocks, comments, and file uploads; or call any REST endpoint directly. Use whenever a task touches Notion: finding pages or databases, reading or editing content, working with database rows, comments, files, or anything else in a Notion workspace."
user-invocable: false
author: Maxime Bourmaud (maximebrmd)
metadata:
  hermes:
    tags: [notion, notes, docs, databases, knowledge-base]
    category: productivity
---

# notion-axi

Agent ergonomic CLI for Notion. Prefer this over the Notion MCP or raw API for Notion operations.

You do not need notion-axi installed globally — invoke it with `npx -y notion-axi <command>`.
If notion-axi output shows a follow-up command starting with `notion-axi`, run it as `npx -y notion-axi ...` instead.

notion-axi wraps the official **Notion CLI (`ntn`)**, which handles authentication for you. `ntn` must be installed and logged in:

- Install: `curl -fsSL https://ntn.dev | bash`
- Log in: `ntn login` (opens a browser; the workspace token is stored in the OS keychain — no page-sharing step, it acts as the user)

If a command fails with `NTN_NOT_INSTALLED`, ask the user to run the install command. If it fails with `AUTH_REQUIRED`, ask them to run `ntn login` (or export `NOTION_API_TOKEN`). One restriction: `users` requires elevated workspace permissions and is often blocked — handle a `RESTRICTED_RESOURCE` error gracefully.

## When to use

Use notion-axi whenever a task touches Notion: searching for pages or databases; reading a page's properties and content; creating a page under another page or as a database row; appending to or replacing a page's content; inspecting a database's schema; or listing database rows.

## Workflow

1. Run `npx -y notion-axi` with no arguments for a content-first view of recently edited pages and databases.
2. `search <query>` to find an item, then note its `id`.
3. `page view <id>` reads properties and the markdown body (previewed to ~1500 chars; add `--full` for everything).
4. `db view <id>` shows a database's schema; `db query <id>` lists rows (title + 3 columns; `--full` for all, `--limit <n>` for more). Narrow server-side with `--where Name=value` (repeatable, typed from the schema) or a raw `--filter <json>`, order with `--sort Field:asc|desc` (repeatable), and page with `--cursor <c>` (the response returns `next_cursor` when `has_more`). `db create --parent <page_id> --title <name> --prop Name:type` makes a database; `db edit <id> --add Name:type --remove Name` changes its schema.
5. `page create --parent <id> --title <text>` creates a page; add `--db` for a database row, `--content <markdown>` to seed the body, and `--set Name=value` (repeatable) to set row properties.
6. `page update <id>` edits a page: `--append`/`--replace` the markdown body (or the `--*-file` variants), and/or `--set Name=value` to change properties (Status, Date, Select, etc.).
7. `page archive <id>` trashes a page (`--restore` to undo); `page move <id> --to <parent>` reparents it. `block list <page_id>` / `block delete <id>` work at the block level; `comments list/add/delete <id>`; `users get <id>`; `whoami` shows the token's identity.
8. `file upload <path> [--attach <page_id>]` uploads a local file (single-part, via a multipart send) and optionally attaches it to a page.
9. `api <method> <path> [--body <json>]` calls any Notion REST endpoint directly — an escape hatch for anything the dedicated commands don't cover.
10. Every response ends with contextual next-step hints under `help:` — follow them.

## Commands

```
commands[11]:
  (none)=home, search, page, db, block, users, comments, whoami, file, api, setup
  page subcommands: view, create, update, archive, move
  db subcommands: view, query, create, edit
  block subcommands: list, delete
  users subcommands: (none)=list, get
  comments subcommands: list, add, delete
  file subcommands: upload
```

Run `npx -y notion-axi --help` for global flags, or `npx -y notion-axi <command> --help` for per-command usage.

## Tips

- Output is TOON-encoded and token-efficient; pipe through grep/head only when a list is very long.
- A `ntn login` workspace token acts as the user, so it can reach everything the user can — an `OBJECT_NOT_FOUND` usually means a wrong id, not a sharing gap.
- For `db` commands, `<id>` may be a database or a data-source id; a database resolves to its first data source automatically (use `--source <id>` to target a specific one).
- Lists are minimal by default — add `--fields url` (search) or `--fields a,b` (db query) to widen, or `--full` for all database columns.
- `db query` filters and sorts server-side: prefer `--where Status=Todo` (compiled from the schema) over fetching all rows and filtering yourself; `--filter <json>` passes a raw Notion filter (mutually exclusive with `--where`). Page in bounded chunks with `--cursor` — the response's `next_cursor` continues where `has_more` left off.
- Page bodies are markdown via the Notion API, so `--append`/`--replace` and `--content` all take markdown (or read it from a file with the `--*-file` flags).
- `--set Name=value` is repeatable and typed by the schema: dates as `start..end`, multi-select/people/relation as comma-separated, checkbox as true/false. `page archive` is idempotent (archiving an archived page is a no-op).
- `whoami` reveals the identity behind the current login (bot vs user) and the workspace; `users` needs elevated workspace permissions and is often `RESTRICTED_RESOURCE`.
- Anything without a dedicated command (views, meeting notes, templates, paginated property items) is reachable through `api` — the entire Notion REST API is available.
- Exit codes: 0 success, 1 error, 2 usage. Errors are structured with an `error`, `code`, and `help` list.
