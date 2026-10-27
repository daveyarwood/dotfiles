---
name: retro-diffusion
description: "Use when asked to generate pixel art: a retro logo, an icon, a sprite, item art, or a portrait. Generates stills with the Retro Diffusion v2 REST API and writes the PNGs to disk."
metadata:
  hermes:
    tags: [pixel-art, images, sprites, logos, api]
    category: creative
---

# Retro Diffusion

Retro Diffusion turns a text prompt into pixel art. This skill covers still
images: logos, icons, sprites, item art, portraits.

Every request is one POST plus a poll. `scripts/generate.py` in this skill does
both and writes the decoded PNGs.

## Setup

The key is read from `RETRO_DIFFUSION_API_KEY` and sent as the `X-RD-Token`
header. Keys start with `rdpk-` and are created at
https://www.retrodiffusion.ai/app/devtools, five per account at most. Send the
key in that header and nowhere else: nothing in this skill writes it to disk, to
a repo, or to a log. If the variable is unset, ask Dave for the key instead of
hunting the filesystem.

Base URL: `https://api.retrodiffusion.ai/v2`. The v1 host still answers and needs
no migration.

## Generate a still

```bash
python3 .agents/skills/retro-diffusion/scripts/generate.py \
  --prompt "a squat round flask of glowing crimson liquid, cork stopper, bright highlight on the upper-left rim" \
  --style rd_pro__default --width 64 --height 64 --remove-bg --out potion.png
```

The script prints the paths it wrote, the charge, and the remaining balance:

```
task 8d24e990-...
wrote potion.png
model rd_pro  cost $0.18  remaining balance $99.82
```

Flags:

- `--prompt` the subject, described concretely. Required.
- `--style` a `prompt_style` id. Defaults to `rd_pro__default`.
- `--width` and `--height` in pixels. Default 64 each. Size limits are per
  style, so check the style list below before going large.
- `--num-images` how many takes of the prompt to generate in one request.
  Default 1.
- `--seed` an integer. Reuse it to iterate on a composition and change only the
  prompt. Omit it for a fresh result each run.
- `--remove-bg` writes a transparent background. Pair it with a flat contrasting
  background named in the prompt.
- `--input-image` a PNG on disk, for img2img. `--strength` says how much to
  change it, 0 to 1, default 0.75 on the API side.
- `--reference-image` a PNG on disk, repeatable, up to 9. RD Pro styles only.
  These guide style and content without redrawing the source.
- `--out` where to write the images. Defaults to `retro-diffusion/<slug>.png`,
  with `-1`, `-2` and so on appended when a request returns more than one image.
- `--check-cost` prints the price and stops without generating or charging.
- `--timeout` seconds to wait for the task. Default 300.

## The API by hand

Three calls, if the script is not the right tool.

Auth is the `X-RD-Token` header on every request. Generation is always async:
the POST is accepted with a `task_id` and the result comes from polling that
task.

Price the request first. `"check_cost": true` is a free dry run that generates
nothing and charges nothing:

```bash
curl -sS https://api.retrodiffusion.ai/v2/inferences \
  -H "X-RD-Token: $RETRO_DIFFUSION_API_KEY" -H 'Content-Type: application/json' \
  -d '{"prompt":"test","prompt_style":"rd_pro__default","width":64,"height":64,"num_images":1,"check_cost":true}'
# {"balance_cost": 0.18, "model": "check_cost", "base64_images": [], "remaining_balance": 99.82}
```

Submit for real. Persist a unique `Idempotency-Key` first, so a lost response
can be retried with identical inputs instead of a second charge:

```bash
curl -sS https://api.retrodiffusion.ai/v2/inferences \
  -H "X-RD-Token: $RETRO_DIFFUSION_API_KEY" -H 'Content-Type: application/json' \
  -H "Idempotency-Key: $(uuidgen)" \
  -d '{"prompt":"a squat round flask of glowing crimson liquid","prompt_style":"rd_pro__default","width":64,"height":64,"num_images":1,"remove_bg":true}'
# {"status":"accepted","task_id":"8d24e990-...","request_id":"8d24e990-...","message":"..."}
```

Poll `GET /v2/inferences/tasks/{task_id}` every couple of seconds until the
status is `succeeded` or `failed`. A success carries the generation:

```json
{"created_at": 1783523045, "balance_cost": 0.18, "base64_images": ["iVBORw0KGgo..."],
 "model": "rd_pro", "remaining_balance": 99.82, "request_id": "8d24e990-..."}
```

`base64_images` holds raw base64 PNG, with no `data:` prefix. Decode each entry
and write it to disk. A large result, an animation in particular, arrives as
hosted urls in `output_urls` with `base64_images` empty, so read both fields.
Pass `"upload_outputs": true` to ask for urls every time.

## Styles

Style ids are opaque strings. Take them from this list or from
`GET /v2/styles/selector`, which returns the live limits. Never infer
capabilities from the prefix.

Image styles charge a flat rate per image at any size. `num_images` is clamped
to the style's cap and the clamped count is what gets charged.

RD Pro, $0.18 per image, the highest quality and the only family that takes
`reference_images`:

- `rd_pro__default`, `__painterly`, `__fantasy`, `__horror`, `__scifi`,
  `__simple`, `__isometric`, `__topdown`, `__platformer`: 12 to 256px, up to 16
  images per request.
- `rd_pro__dungeon_map`, `__spritesheet`, `__typography`: 64 to 256px, up to 4.
  `__fps_weapon` is also $0.25.
- `rd_pro__hexagonal_tiles`, `__ui_panel`, `__inventory_items`: 256x256 only,
  up to 4.
- `rd_pro__pixelate` and `rd_pro__edit` need `input_image`.
  `__pixelate` is 16 to 256px and converts an existing image into pixel art,
  `__edit` is 64 to 256px.

RD Plus, $0.06 per image:

- `default`, `retro`, `watercolor`, `textured`, `cartoon`, `ui_element`,
  `item_sheet`, `character_turnaround`, `environment`, `isometric`,
  `isometric_asset`, `topdown_map`, `topdown_asset`: 64 to 384px, up to 16.
- `classic` and `skill_icon`: 32 to 192px.
- `low_res`, `mc_item`, `mc_texture`: 16 to 128px.
- `topdown_item`: 16 to 96px.

RD Fast, $0.03 per image, the cheapest way to draft:

- `default`, `simple`, `detailed`, `retro`, `game_asset`, `portrait`,
  `texture`, `ui`, `item_sheet`, `character_turnaround`, `no_style`, `1_bit`:
  64 to 384px, up to 16, and 15 for `default`.
- `low_res`, `mc_item`, `mc_texture`: 16 to 128px.

RD Mini at $0.06, or $0.03 for the `fast_` ids, aliases the Plus and Fast
low-res styles and its response names the routed model: `classic`, `skill_icon`,
`low_res`, `mc_item`, `mc_texture`, `fast_low_res`, `fast_mc_item`,
`fast_mc_texture`, `topdown_item`.

## Picking a size and a background

Retro Diffusion's own defaults, by what the image is for. Size is per item, not
per sheet.

- Minecraft items and textures 16px.
- Items, icons, props, critters 32 to 64px.
- Character sprites 16 to 48px retro, 96 to 128px for a showcase piece.
- Single tiles 16 to 32px.
- Dialogue busts 64px, portraits 96 to 128px.
- Scenes and key art 256px, which is RD Pro's ceiling, or 256x144 for 16:9.

For a standalone asset, name a flat background color that contrasts the subject
in the prompt, white by default, and pass `remove_bg`. Writing "on a transparent
background" into a prompt does nothing, and leaving the background unstated
drifts to a dark gray that dulls the contrast and the cutout. Scenes go the
other way: describe the environment and leave `remove_bg` off.

`num_images` gives varied takes of one prompt, which is how to get nine
different swords. It does not separate requested items. Per-item sizing cannot
be guaranteed inside one image, so ask for N images when N usable items are
wanted, and reach for a sheet style only when the sheet itself is the
deliverable.

For variants of one image, seasons or weather or a recolour, generate the base
once and derive each variant with the `image_edit` tool. Separate generations of
the same prompt come back as unrelated compositions. For one character across
several images, generate it once with RD Pro and pass that output as a
`reference_image` afterwards. Pass an existing image to `rd_pro__pixelate` to
convert it; `reference_images` re-imagines rather than converts.

## Costs and balance

`GET /v2/inferences/credits` returns the prepaid balance:

```json
{"credits": 0, "balance": 100.75}
```

A generation is charged before it runs and refunded automatically when it fails.
`check_cost` is the free way to price anything, including a submission that is
otherwise identical to a real one.

## Failures and recovery

Rotate tasks to a terminal state before believing anything. The v2 error shape
is `{"error": {"code", "message", "request_id"}}`, and the failure codes on a
task are `inference_failed`, which is worth one retry with identical parameters,
`provider_busy`, worth waiting a few minutes, and `provider_timeout` or
`request_timeout`, worth a plain retry. Every one of them is refunded.

Status codes: 400 bad input, 401 bad key, 402 no balance, 403 forbidden, 404
missing, 409 conflict, 413 too large, 422 schema, 429 rate limited, 500
unexpected, 502 provider failure, 503 unavailable, 504 timeout.

If the submission response was lost, do not submit again blind. Ask for the
recent tasks and resume polling:

```bash
curl -sS "https://api.retrodiffusion.ai/v2/inferences/tasks?limit=20" \
  -H "X-RD-Token: $RETRO_DIFFUSION_API_KEY"
```

Every call the key makes is recorded, with outputs retrievable for 24 hours and
metadata for 30 days, so `GET /v2/inferences/requests?limit=20` recovers results
after a client timeout even without the request id. Each entry carries a fresh
15 minute signed url. `GET /v2/status` needs no auth and reports which models
are up, which is worth one call before a batch.

## The rest of the API

Same host, same `X-RD-Token` header. All of it is out of scope for this skill
so far, and this is where each one lives.

- Animations. `rd_animation__*` styles build a subject from the prompt,
  `rd_advanced_animation__*` animates an `input_image` that must match the
  request's width and height, and both return GIFs or a spritesheet with
  `return_spritesheet`. `rd_advanced_animation__rotate` gives the other seven
  directional views of a sprite, and it has no fallback provider, so
  `provider_busy` is common on it.
- Tilesets. `rd_tile__tileset`, `__tileset_advanced`, which takes
  `extra_prompt` for a second texture, `__single_tile`, `__tile_variation`,
  `__tile_object`, `__scene_object`, plus `tile_x` and `tile_y` for seamless
  output.
- Canvas edit tools. `GET /v2/edit/tools` lists them with prices, and
  `POST /v2/edit/tools/{tool_id}` runs one: `image_edit`, `inpainting` and
  `outpainting` and `seam_tiling` at $0.18, `background_remover` and
  `color_style_transfer` at $0.01, and `rotate`, `pixel_correction`, `color_reducer`,
  `palette_converter` and `k_centroid_downscale` at $0.001. Append `/tasks` to
  run one asynchronously and poll `GET /v2/edit/tasks/{task_id}`. These deliver
  the image in `output_urls` rather than `base64_images`.
- Pixel Fixer. `POST /v2/pixel-fixer/standard` at $0.002 and `/neural` at
  $0.005 reconstruct a clean pixel grid from a screenshot or a scaled-up sprite.
- Low-poly 3D. `POST /v2/lowpoly/generate` builds a textured low-poly model from
  a prompt and up to 4 reference images, and `/lowpoly/assets/{asset_id}` revises,
  animates, splits, re-rigs, recolours and exports it to glTF, Blockbench,
  Minecraft, Unity, Godot, Unreal or Blender. Models run $0.25 to $3.00 by size.
- Assistant. `POST /v1/assistant/sessions` is a conversational path that picks
  styles itself, proposes a priced plan and generates only after approval,
  which is the way to drive this unattended. $0.01 per message.
- Custom styles. `POST /v2/styles` registers a `user__<name>_<id>` style from
  one reference image, for a house look reused across assets.

Read the vendor's agent reference before extending any of that:
`llms.txt` at https://github.com/Retro-Diffusion/api-examples, which is the file
this skill is drawn from and the one to re-read when the API moves. The
human-readable reference with an interactive style explorer is at
https://www.retrodiffusion.ai/app/guide/api, runnable example scripts are in the
same api-examples repo, and the deeper guides ship beside `llms.txt` as
`LOW_POLY.md`, `ASSISTANT.md` and `EDIT_TOOLS.md`.
