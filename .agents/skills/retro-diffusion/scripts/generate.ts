// Generate pixel-art stills with the Retro Diffusion v2 API.
//
// Submits one inference, polls the task to a terminal state, and writes the
// decoded PNGs to disk. The key is read from RETRO_DIFFUSION_API_KEY and is
// never written to disk or printed.
//
//     node .agents/skills/retro-diffusion/scripts/generate.ts \
//         --prompt "a squat round flask of glowing crimson liquid" \
//         --style rd_pro__default --width 64 --height 64 --remove-bg --out potion.png
//
//     node .agents/skills/retro-diffusion/scripts/generate.ts --prompt "test" --check-cost
//
// Node 22.18 or newer strips the type annotations as it loads the file, so
// there is nothing to install and no build step. The full API, including
// animations, tilesets, edit tools, the Pixel Fixer and low-poly 3D, is
// documented in SKILL.md next to this file.

import { randomUUID } from "node:crypto";
import { join } from "node:path";
import { parseArgs } from "node:util";

import {
  type InferencePayload,
  checkCost as costQuote,
  encodeImage,
  fail,
  pollTask,
  submitInference,
  writeImages,
} from "./api.ts";

const DEFAULT_TIMEOUT_SECONDS = 300;

// The API reports dollars as floats, so 2.08 arrives as 2.0800000000000005 and
// has to be trimmed back to cents before it is printed.
const money = (value: number): string => value.toFixed(2);

const USAGE = `Usage: node generate.ts --prompt <text> [options]

  --prompt <text>          the subject, described concretely (required)
  --style <id>             prompt_style id, default rd_pro__default
  --width <px>             default 64
  --height <px>            default 64
  --num-images <n>         takes of the prompt in one request, default 1
  --seed <int>             reuse it to iterate on a composition
  --extra-prompt <text>    second texture for tileset styles
  --input-image <png>      source for img2img
  --strength <0-1>         how much to change the input image
  --reference-image <png>  repeatable, RD Pro styles only, up to 9
  --remove-bg              write a transparent background
  --out <path>             default retro-diffusion/<slug>.png
  --timeout <seconds>      how long to wait for the task, default 300
  --check-cost             print the price and stop, free and charges nothing`;

type GenerateOptions = {
  prompt: string;
  style: string;
  width: number;
  height: number;
  numImages: number;
  seed?: number;
  extraPrompt?: string;
  inputImage?: string;
  strength?: number;
  referenceImages?: string[];
  removeBg: boolean;
  out?: string;
  timeout: number;
  checkCost: boolean;
};

// Parsing, converting and validating all live here, so every caller gets a
// GenerateOptions rather than the raw strings parseArgs hands back.
const parseOptions = (argv: string[]): GenerateOptions => {
  try {
    const {
      prompt,
      style,
      width,
      height,
      "num-images": numImages,
      seed,
      "extra-prompt": extraPrompt,
      "input-image": inputImage,
      strength,
      "reference-image": referenceImages,
      "remove-bg": removeBg,
      out,
      timeout,
      "check-cost": checkCost,
    } = parseArgs({
      args: argv,
      allowPositionals: false,
      options: {
        prompt: { type: "string" },
        style: { type: "string", default: "rd_pro__default" },
        width: { type: "string", default: "64" },
        height: { type: "string", default: "64" },
        "num-images": { type: "string", default: "1" },
        seed: { type: "string" },
        "extra-prompt": { type: "string" },
        "input-image": { type: "string" },
        strength: { type: "string" },
        "reference-image": { type: "string", multiple: true },
        "remove-bg": { type: "boolean" },
        out: { type: "string" },
        timeout: { type: "string", default: `${DEFAULT_TIMEOUT_SECONDS}` },
        "check-cost": { type: "boolean" },
      },
    }).values;

    if (prompt === undefined || prompt === "") {
      return fail(`--prompt is required\n\n${USAGE}`);
    }

    return {
      prompt,
      style,
      width: asNumber("width", width, true),
      height: asNumber("height", height, true),
      numImages: asNumber("num-images", numImages, true),
      seed: asOptionalNumber("seed", seed, true),
      extraPrompt,
      inputImage,
      strength: asOptionalNumber("strength", strength, false),
      referenceImages,
      removeBg: removeBg ?? false,
      out,
      timeout: asNumber("timeout", timeout, false),
      checkCost: checkCost ?? false,
    };
  } catch (error) {
    return fail(`${error instanceof Error ? error.message : String(error)}\n\n${USAGE}`);
  }
};

const asNumber = (name: string, raw: string, whole: boolean): number => {
  const value = Number(raw);
  if (!Number.isFinite(value) || (whole && !Number.isInteger(value))) {
    return fail(`--${name} must be ${whole ? "a whole number" : "a number"}, got "${raw}"`);
  }
  return value;
};

const asOptionalNumber = (name: string, raw: string | undefined, whole: boolean): number | undefined =>
  raw === undefined ? undefined : asNumber(name, raw, whole);

// Keys the API treats as absent rather than null, so an unset flag has to drop
// out of the payload instead of travelling as undefined.
const defined = <K extends keyof InferencePayload>(
  key: K,
  value: InferencePayload[K] | undefined,
): Partial<InferencePayload> => (value === undefined ? {} : { [key]: value });

const imagePayload = (path: string | undefined): Promise<string | undefined> =>
  path === undefined ? Promise.resolve(undefined) : encodeImage(path);

const imageListPayload = (paths: string[] | undefined): Promise<string[] | undefined> =>
  paths === undefined ? Promise.resolve(undefined) : Promise.all(paths.map(encodeImage));

const defaultOut = (prompt: string): string => {
  const slug = prompt
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+/, "")
    .slice(0, 40)
    .replace(/-+$/, "");
  return join("retro-diffusion", `${slug || "image"}.png`);
};

const main = async (argv: string[]): Promise<void> => {
  const {
    prompt,
    style,
    width,
    height,
    numImages,
    seed,
    extraPrompt,
    inputImage,
    strength,
    referenceImages,
    removeBg,
    out,
    timeout,
    checkCost,
  } = parseOptions(argv);

  const token = process.env.RETRO_DIFFUSION_API_KEY;
  if (token === undefined || token === "") {
    return fail("RETRO_DIFFUSION_API_KEY is not set.");
  }

  const payload: InferencePayload = {
    prompt,
    prompt_style: style,
    width,
    height,
    num_images: numImages,
    ...defined("seed", seed),
    ...defined("extra_prompt", extraPrompt),
    ...defined("strength", strength),
    ...defined("input_image", await imagePayload(inputImage)),
    ...defined("reference_images", await imageListPayload(referenceImages)),
    ...defined("remove_bg", removeBg ? true : undefined),
  };

  if (checkCost) {
    const quote = await costQuote(token, payload);
    console.log(`cost $${money(quote.balance_cost)}  remaining balance $${money(quote.remaining_balance)}`);
    return;
  }

  const accepted = await submitInference(token, payload, randomUUID());
  console.log(`task ${accepted.task_id}`);
  const result = await pollTask(accepted.task_id, token, timeout);

  const outputPath = out ?? defaultOut(prompt);
  for (const path of await writeImages(result, outputPath)) {
    console.log(`wrote ${path}`);
  }
  console.log(
    `model ${result.model}  cost $${money(result.balance_cost)}  ` +
      `remaining balance $${money(result.remaining_balance)}`,
  );
};

await main(process.argv.slice(2));
