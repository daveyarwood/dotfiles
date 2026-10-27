// The Retro Diffusion v2 wire layer: one POST, a poll, and PNGs on disk.
//
// Field names stay as the API spells them, so the JSON going in and out of
// here can be read against the vendor docs without a translation step.

import { mkdir, readFile, writeFile } from "node:fs/promises";
import { dirname, join, parse } from "node:path";

export const BASE_URL = "https://api.retrodiffusion.ai/v2";

const POLL_INTERVAL_MS = 2_000;
const REQUEST_TIMEOUT_MS = 60_000;
const DOWNLOAD_TIMEOUT_MS = 120_000;
const PNG_MAGIC = Buffer.from([0x89, 0x50, 0x4e, 0x47]);

export type InferencePayload = {
  prompt: string;
  prompt_style: string;
  width: number;
  height: number;
  num_images: number;
  seed?: number;
  extra_prompt?: string;
  strength?: number;
  input_image?: string;
  reference_images?: string[];
  remove_bg?: boolean;
  check_cost?: boolean;
};

export type CostQuote = {
  balance_cost: number;
  remaining_balance: number;
};

export type AcceptedTask = {
  task_id: string;
};

export type GenerationResult = {
  model: string;
  balance_cost: number;
  remaining_balance: number;
  base64_images?: string[];
  output_urls?: string[];
};

type TaskPoll = {
  status: string;
  result?: GenerationResult;
  error?: { detail?: string };
};

type ApiError = {
  code?: string;
  message?: string;
  request_id?: string;
};

// Annotated rather than inferred, so the compiler treats every call as the
// terminating branch it is and stops asking about values that cannot be unset
// past the check.
export const fail: (message: string) => never = (message) => {
  console.error(`error: ${message}`);
  process.exit(1);
};

const sleep = (milliseconds: number): Promise<void> =>
  new Promise((resolve) => setTimeout(resolve, milliseconds));

const parseJson = (text: string): unknown => {
  try {
    return JSON.parse(text);
  } catch {
    return undefined;
  }
};

const errorOf = (body: unknown): ApiError | undefined => {
  if (typeof body !== "object" || body === null || !("error" in body)) {
    return undefined;
  }
  const { error } = body as { error?: unknown };
  return typeof error === "object" && error !== null ? (error as ApiError) : undefined;
};

type RequestOptions = {
  path: string;
  token: string;
  payload?: InferencePayload;
  idempotencyKey?: string;
};

// The one place the wire JSON becomes a typed value. Everything above this
// line is checked against the types; this is where the docs and the API are
// taken at their word.
const requestJson = async <T>({ path, token, payload, idempotencyKey }: RequestOptions): Promise<T> => {
  const response = await fetch(`${BASE_URL}${path}`, {
    method: payload === undefined ? "GET" : "POST",
    headers: {
      "X-RD-Token": token,
      ...(payload === undefined ? {} : { "Content-Type": "application/json" }),
      ...(idempotencyKey === undefined ? {} : { "Idempotency-Key": idempotencyKey }),
    },
    body: payload === undefined ? undefined : JSON.stringify(payload),
    signal: AbortSignal.timeout(REQUEST_TIMEOUT_MS),
  }).catch((reason: unknown) => fail(`cannot reach ${BASE_URL}: ${reason}`));

  const text = await response.text();
  if (response.ok) {
    const body = parseJson(text);
    return (body === undefined ? fail(`unreadable response from ${path}: ${text.slice(0, 400)}`) : body) as T;
  }

  const problem = errorOf(parseJson(text));
  fail(
    problem === undefined
      ? `HTTP ${response.status}: ${text.slice(0, 400)}`
      : `HTTP ${response.status} ${problem.code}: ${problem.message} request_id=${problem.request_id}`,
  );
};

export const checkCost = (token: string, payload: InferencePayload): Promise<CostQuote> =>
  requestJson<CostQuote>({ path: "/inferences", token, payload: { ...payload, check_cost: true } });

export const submitInference = (
  token: string,
  payload: InferencePayload,
  idempotencyKey: string,
): Promise<AcceptedTask> => requestJson<AcceptedTask>({ path: "/inferences", token, payload, idempotencyKey });

export const pollTask = async (
  taskId: string,
  token: string,
  timeoutSeconds: number,
): Promise<GenerationResult> => {
  const deadline = Date.now() + timeoutSeconds * 1000;
  while (Date.now() < deadline) {
    const task = await requestJson<TaskPoll>({ path: `/inferences/tasks/${taskId}`, token });
    if (task.status === "succeeded") {
      return task.result ?? fail(`task ${taskId} succeeded without a result`);
    }
    if (task.status === "failed") {
      fail(`generation failed: ${task.error?.detail ?? JSON.stringify(task.error ?? {})}`);
    }
    await sleep(POLL_INTERVAL_MS);
  }
  return fail(
    `task ${taskId} is still running after ${timeoutSeconds.toFixed(0)}s. It keeps running on the ` +
      `server, so recover it with GET ${BASE_URL}/inferences/tasks/${taskId} instead of submitting again.`,
  );
};

const targetPaths = (out: string, count: number): string[] => {
  if (count === 1) {
    return [out];
  }
  const { dir, name, ext } = parse(out);
  return Array.from({ length: count }, (_, index) => join(dir, `${name}-${index + 1}${ext}`));
};

const fetchImage = async (url: string): Promise<Buffer> => {
  const response = await fetch(url, { signal: AbortSignal.timeout(DOWNLOAD_TIMEOUT_MS) }).catch(
    (reason: unknown) => fail(`cannot download ${url}: ${reason}`),
  );
  return response.ok
    ? Buffer.from(await response.arrayBuffer())
    : fail(`cannot download ${url}: HTTP ${response.status}`);
};

export const writeImages = async (result: GenerationResult, out: string): Promise<string[]> => {
  const images = result.base64_images ?? [];
  const urls = result.output_urls ?? [];
  const count = Math.max(images.length, urls.length);
  if (count === 0) {
    return fail("the result carried no base64_images and no output_urls");
  }

  const targets = targetPaths(out, count);
  await Promise.all(
    targets.map(async (target, index) => {
      const inline = images[index];
      const hosted = urls[index];
      const bytes =
        inline !== undefined
          ? Buffer.from(inline, "base64")
          : hosted !== undefined
            ? await fetchImage(hosted)
            : fail(`the result has no image at index ${index}`);
      await mkdir(dirname(target), { recursive: true });
      await writeFile(target, bytes);
    }),
  );
  return targets;
};

export const encodeImage = async (path: string): Promise<string> => {
  const data = await readFile(path).catch((reason: unknown) => fail(`cannot read ${path}: ${reason}`));
  return data.subarray(0, PNG_MAGIC.length).equals(PNG_MAGIC)
    ? data.toString("base64")
    : fail(`${path} is not a PNG. The API takes PNG inputs only.`);
};
