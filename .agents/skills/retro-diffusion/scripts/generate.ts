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
  checkCost,
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

const parseOptions = (argv: string[]) => {
  try {
    return parseArgs({
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
  const values = parseOptions(argv);
  const prompt = values.prompt;
  if (prompt === undefined || prompt === "") {
    return fail(`--prompt is required\n\n${USAGE}`);
  }

  const token = process.env.RETRO_DIFFUSION_API_KEY;
  if (token === undefined || token === "") {
    return fail("RETRO_DIFFUSION_API_KEY is not set. Ask Dave for the key.");
  }

  const options: GenerateOptions = {
    prompt,
    style: values.style,
    width: asNumber("width", values.width, true),
    height: asNumber("height", values.height, true),
    numImages: asNumber("num-images", values["num-images"], true),
    seed: asOptionalNumber("seed", values.seed, true),
    extraPrompt: values["extra-prompt"],
    inputImage: values["input-image"],
    strength: asOptionalNumber("strength", values.strength, false),
    referenceImages: values["reference-image"],
    removeBg: values["remove-bg"] ?? false,
    out: values.out,
    timeout: asNumber("timeout", values.timeout, false),
    checkCost: values["check-cost"] ?? false,
  };

  const payload: InferencePayload = {
    prompt: options.prompt,
    prompt_style: options.style,
    width: options.width,
    height: options.height,
    num_images: options.numImages,
    ...defined("seed", options.seed),
    ...defined("extra_prompt", options.extraPrompt),
    ...defined("strength", options.strength),
    ...defined("input_image", await imagePayload(options.inputImage)),
    ...defined("reference_images", await imageListPayload(options.referenceImages)),
    ...defined("remove_bg", options.removeBg ? true : undefined),
  };

  if (options.checkCost) {
    const quote = await checkCost(token, payload);
    console.log(`cost $${money(quote.balance_cost)}  remaining balance $${money(quote.remaining_balance)}`);
    return;
  }

  const accepted = await submitInference(token, payload, randomUUID());
  console.log(`task ${accepted.task_id}`);
  const result = await pollTask(accepted.task_id, token, options.timeout);

  const out = options.out ?? defaultOut(options.prompt);
  for (const path of await writeImages(result, out)) {
    console.log(`wrote ${path}`);
  }
  console.log(
    `model ${result.model}  cost $${money(result.balance_cost)}  ` +
      `remaining balance $${money(result.remaining_balance)}`,
  );
};

await main(process.argv.slice(2));
