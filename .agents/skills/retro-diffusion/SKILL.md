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

Every request is one POST plus a poll. `scripts/generate.ts` in this skill does
both and writes the decoded PNGs.

## Setup

The key is read from `RETRO_DIFFUSION_API_KEY` and sent as the `X-RD-Token`
header. Keys start with `rdpk-` and are created at
https://www.retrodiffusion.ai/app/devtools, five per account at most. Send the
key in that header and nowhere else: nothing in this skill writes it to disk, to
a repo, or to a log. If the variable is unset, ask Dave for the key instead of
hunting the filesystem.

The script is TypeScript with no dependencies, so there is nothing to install
and no build step. Node 22.18 or newer runs it directly, using its own type
stripping, and imports only globals and `node:` builtins. `node --version` says
which one you have.

Base URL: `https://api.retrodiffusion.ai/v2`. The v1 host still answers and needs
no migration.

## Generate a still

```bash
node .agents/skills/retro-diffusion/scripts/generate.ts \
  --prompt "a squat round flask of glowing crimson liquid, cork stopper, bright highlight on the upper-left rim" \
  --style rd_lite__default --width 64 --height 64 --remove-bg --out potion.png
```

The script prints the paths it wrote, the charge, and the remaining balance:

```
task 96454631-...
wrote potion.png
model rd_lite  cost $0.05  remaining balance $27.87
```

Flags:

- `--prompt` the subject, described concretely. Required.
- `--style` a `prompt_style` id. Defaults to `rd_lite__default`.
- `--width` and `--height` in pixels. Default 64 each. Size limits are per
  style, so check the selector before going large.
- `--num-images` how many takes of the prompt to generate in one request.
  Default 1.
- `--seed` an integer. It travels on the request and does not make the output
  repeatable: two runs of one prompt at one seed come back as unrelated images,
  on `rd_lite`, `rd_core` and `rd_pro` alike. Get several takes of one prompt
  from `--num-images`, and carry a look from image to image with
  `--reference-image` or `--input-image`.
- `--remove-bg` writes a transparent background. Pair it with a flat contrasting
  background named in the prompt.
- `--input-image` a PNG on disk, for img2img. `--strength` says how much to
  change it, 0 to 1, default 0.75 on the API side.
- `--reference-image` a PNG on disk, repeatable, up to 9. Its
  `supports_reference_images` flag in the selector marks every `rd_lite`,
  `rd_core` and `rd_pro` style plus three of the `rd_animation` styles.
  References guide style and content without redrawing the source. The vendor
  documents nine for Core and Pro and one for Lite, though the API accepted ten
  on an `rd_lite__default` run.
- `--out` where to write the images. Defaults to `retro-diffusion/<slug>.png`,
  with `-1`, `-2` and so on appended when a request returns more than one image.
- `--check-cost` prints the price and stops without generating or charging.
- `--timeout` seconds to wait for the task. Default 300.

## The API by hand

Not documented here. `scripts/api.ts` is the wire format: the `X-RD-Token`
header, the `Idempotency-Key`, the free `check_cost` dry run, the submit, the
poll path, and the read of `base64_images` against `output_urls`, all under the
field names the API itself uses. Read it before reaching for curl.

One flag the script does not send: `upload_outputs: true` asks for hosted urls
on every response instead of base64.

## Styles

Style ids are opaque strings. The lists below carry the two families this skill
reaches for, and `GET /v2/styles/selector` returns the live limits for every
style in the API. Never infer capabilities from the prefix.

Image styles charge a flat rate per image at any size. `num_images` is clamped
to the style's cap and the clamped count is what gets charged.

RD Lite is the default at $0.05 an image, about half of RD Core, and the
vendor's pick for most stills: sprites, icons, items, quick drafts, variations.
It comes back in about six seconds and carries every RD Core style but
`__inventory_items`. RD Core is $0.10 an image on a heavier model, for busy,
complex scenes. Both of them share these limits:

- the nine `default`, `painterly`, `simple`, `fantasy`, `horror`, `scifi`,
  `isometric`, `topdown` and `platformer` styles: 16 to 512px, up to 4 images
  per request.
- `dungeon_map`, `spritesheet`, `hexagonal_tiles`: 128 to 512px, up to 4.
- `fps_weapon`, `typography`: 64 to 512px, up to 4.
- `rd_lite__ui_panel`: 256 to 512px, up to 4, where `rd_core__ui_panel` is
  256x256 only.
- `rd_core__inventory_items`: 128 to 512px, up to 4, on Core alone.

RD Plus, RD Fast and RD Mini are cheaper draft tiers. Their ids and limits are
in the selector. `rd_mini` aliases the Plus and Fast low-res styles, and its
response names the routed model. RD Fast left the website when RD Lite replaced
it there, and stays in the API at $0.03 for the ids only it carries.

## Picking a size and a background

Retro Diffusion's own defaults, by what the image is for. Size is per item, not
per sheet.

- Minecraft items and textures 16px.
- Items, icons, props, critters 32 to 64px.
- Character sprites 16 to 48px retro, 96 to 128px for a showcase piece.
- Single tiles 16 to 32px.
- Dialogue busts 64px, portraits 96 to 128px.
- Scenes and key art 512px, which is the ceiling on `rd_lite` and `rd_core`, or
  512x288 for 16:9.

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
several images, generate it once with `rd_core__default` and pass that output as
a `reference_image` afterwards, because Core and Pro carry nine references each
where the Lite styles are documented at one. Pro adds nothing else here. Pass an
existing image to `rd_pro__pixelate` to convert it; `reference_images`
re-imagines rather than converts.

## Costs and balance

`GET /v2/inferences/credits` returns the prepaid balance:

```json
{"credits": 0, "balance": 100.75}
```

A generation is charged before it runs and refunded automatically when it fails.
`check_cost` is the free way to price anything, including a submission that is
otherwise identical to a real one. Price is per image and does not move with
size: `rd_lite` $0.05, `rd_core` $0.10, `rd_pro` $0.18, `rd_plus` $0.06,
`rd_fast` $0.03, and `rd_mini` $0.06 or $0.03 for the `fast_` ids. `check_cost`
quotes $0.05 for `rd_lite__default` at both 64px and 512px and $0.20 for
`rd_lite__dungeon_map` with `num_images` 4, $0.10 for `rd_core__default` at both
64px and 512px, and $0.40 for `rd_core__dungeon_map` with `num_images` 4.

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
this skill is drawn from and the one to re-read when the API moves, though the
`README.md` beside it runs ahead on the models. The human-readable reference with
an interactive style explorer is at
https://www.retrodiffusion.ai/app/guide/api, runnable example scripts are in the
same api-examples repo, and the deeper guides ship beside `llms.txt` as
`LOW_POLY.md`, `ASSISTANT.md` and `EDIT_TOOLS.md`.
