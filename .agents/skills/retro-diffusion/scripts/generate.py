#!/usr/bin/env python3
"""Generate pixel-art stills with the Retro Diffusion v2 API.

Submits one inference, polls the task to a terminal state, and writes the
decoded PNGs to disk. The key is read from RETRO_DIFFUSION_API_KEY and is
never written to disk or printed.

    python3 generate.py --prompt "a squat round flask of glowing crimson liquid" \
        --style rd_pro__default --width 64 --height 64 --remove-bg --out potion.png

    python3 generate.py --prompt "test" --check-cost   # free price check

The full API, including animations, tilesets, edit tools, the Pixel Fixer and
low-poly 3D, is documented in SKILL.md next to this file.
"""

import argparse
import base64
import json
import os
import re
import sys
import time
import urllib.error
import urllib.request
import uuid
from pathlib import Path
from typing import NoReturn

BASE_URL = "https://api.retrodiffusion.ai/v2"
POLL_INTERVAL_SECONDS = 2.0


def fail(message: str) -> NoReturn:
    print(f"error: {message}", file=sys.stderr)
    raise SystemExit(1)


def request(path: str, token: str, payload: dict | None = None, idempotency_key: str | None = None) -> dict:
    headers = {"X-RD-Token": token}
    data = None
    if payload is not None:
        headers["Content-Type"] = "application/json"
        data = json.dumps(payload).encode()
    if idempotency_key:
        headers["Idempotency-Key"] = idempotency_key
    req = urllib.request.Request(f"{BASE_URL}{path}", data=data, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=60) as response:
            return json.loads(response.read())
    except urllib.error.HTTPError as exc:
        raw = exc.read().decode(errors="replace")
        try:
            problem = json.loads(raw)["error"]
        except (ValueError, KeyError, TypeError):
            fail(f"HTTP {exc.code}: {raw[:400]}")
        fail(
            f"HTTP {exc.code} {problem.get('code')}: {problem.get('message')} "
            f"request_id={problem.get('request_id')}"
        )
    except urllib.error.URLError as exc:
        fail(f"cannot reach {BASE_URL}: {exc.reason}")


def poll_task(task_id: str, token: str, timeout_seconds: float) -> dict:
    deadline = time.monotonic() + timeout_seconds
    while time.monotonic() < deadline:
        task = request(f"/inferences/tasks/{task_id}", token)
        status = task.get("status")
        if status == "succeeded":
            return task["result"]
        if status == "failed":
            error = task.get("error") or {}
            fail(f"generation failed: {error.get('detail') or json.dumps(error)}")
        time.sleep(POLL_INTERVAL_SECONDS)
    fail(
        f"task {task_id} is still running after {timeout_seconds:.0f}s. It keeps "
        f"running on the server, so recover it with "
        f"GET {BASE_URL}/inferences/tasks/{task_id} instead of submitting again."
    )


def target_paths(out: Path, count: int) -> list[Path]:
    if count == 1:
        return [out]
    return [out.with_name(f"{out.stem}-{index + 1}{out.suffix}") for index in range(count)]


def write_images(result: dict, out: Path) -> list[Path]:
    images = result.get("base64_images") or []
    urls = result.get("output_urls") or []
    count = max(len(images), len(urls))
    if count == 0:
        fail("the result carried no base64_images and no output_urls")
    written = []
    for index, target in enumerate(target_paths(out, count)):
        target.parent.mkdir(parents=True, exist_ok=True)
        if index < len(images) and images[index]:
            target.write_bytes(base64.b64decode(images[index]))
        else:
            with urllib.request.urlopen(urls[index], timeout=120) as response:
                target.write_bytes(response.read())
        written.append(target)
    return written


def encode_image(path: str) -> str:
    data = Path(path).read_bytes()
    if not data.startswith(b"\x89PNG"):
        fail(f"{path} is not a PNG. The API takes PNG inputs only.")
    return base64.b64encode(data).decode()


def default_out(prompt: str) -> Path:
    slug = re.sub(r"[^a-z0-9]+", "-", prompt.lower()).strip("-")[:40].strip("-")
    return Path("retro-diffusion") / f"{slug or 'image'}.png"


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate pixel art with Retro Diffusion v2.")
    parser.add_argument("--prompt", required=True, help="the subject, described concretely")
    parser.add_argument("--style", default="rd_pro__default", help="prompt_style id")
    parser.add_argument("--width", type=int, default=64)
    parser.add_argument("--height", type=int, default=64)
    parser.add_argument("--num-images", type=int, default=1)
    parser.add_argument("--seed", type=int, default=None, help="reuse to iterate on a composition")
    parser.add_argument("--extra-prompt", default=None, help="second texture for tileset styles")
    parser.add_argument("--input-image", default=None, help="base64 source for img2img")
    parser.add_argument("--strength", type=float, default=None, help="0 to 1, how much to change it")
    parser.add_argument(
        "--reference-image", action="append", default=None, help="repeatable, RD Pro styles only"
    )
    parser.add_argument("--remove-bg", action="store_true", help="transparent background")
    parser.add_argument("--out", default=None, help="output path, default retro-diffusion/<slug>.png")
    parser.add_argument("--timeout", type=float, default=300.0, help="seconds to wait for the task")
    parser.add_argument("--check-cost", action="store_true", help="print the price and stop")
    return parser.parse_args(argv)


def main(argv: list[str]) -> int:
    args = parse_args(argv)
    token = os.environ.get("RETRO_DIFFUSION_API_KEY")
    if not token:
        fail("RETRO_DIFFUSION_API_KEY is not set. Ask Dave for the key.")

    payload = {
        "prompt": args.prompt,
        "prompt_style": args.style,
        "width": args.width,
        "height": args.height,
        "num_images": args.num_images,
    }
    if args.seed is not None:
        payload["seed"] = args.seed
    if args.extra_prompt:
        payload["extra_prompt"] = args.extra_prompt
    if args.input_image:
        payload["input_image"] = encode_image(args.input_image)
    if args.strength is not None:
        payload["strength"] = args.strength
    if args.reference_image:
        payload["reference_images"] = [encode_image(path) for path in args.reference_image]
    if args.remove_bg:
        payload["remove_bg"] = True

    if args.check_cost:
        payload["check_cost"] = True
        quote = request("/inferences", token, payload)
        print(f"cost ${quote['balance_cost']}  remaining balance ${quote['remaining_balance']}")
        return 0

    accepted = request("/inferences", token, payload, idempotency_key=str(uuid.uuid4()))
    task_id = accepted["task_id"]
    print(f"task {task_id}")
    result = poll_task(task_id, token, args.timeout)

    out = Path(args.out) if args.out else default_out(args.prompt)
    for path in write_images(result, out):
        print(f"wrote {path}")
    print(
        f"model {result.get('model')}  cost ${result.get('balance_cost')}  "
        f"remaining balance ${result.get('remaining_balance')}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
