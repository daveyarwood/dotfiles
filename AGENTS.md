# AGENTS.md

Working rules for AI agents in this dotfiles repo.

## Critical rules

1. **Never run `stow` against the live `$HOME`.** `stow .` symlinks the whole
   repo into `~` and can break an existing setup. Only run it via `./install.sh`,
   and only on a fresh machine. For a safe dry-run use a scratch target:
   `stow --target=/tmp/scratch-home -n .` (needs `stow` installed; `-n` simulates).

2. **Home-mirror layout.** The repo root maps to `$HOME`; every repo path is the
   literal path under `~` (dot-dirs `.config/…`, dot-files `.vimrc`, etc.). Use
   `git mv` for moves/renames to preserve history, and keep every path
   home-relative.

3. **Track only portable config.** Never commit secrets, tokens, keys, caches,
   history, or generated files — e.g. `.clj-kondo/`, `.lsp/` (caches),
   `.cpcache/`, `tags`, `.skill-lock.json`, `fish_history`, `fish_variables`.
   (Some of these are already gitignored; confirm before relying on it.)

## stow specifics

- `.stow-local-ignore` **replaces** stow's built-in default ignore list (not
  additive). It must list *everything* that shouldn't be symlinked into `~`:
  version-control metadata (`.git`, `.gitignore`, `.gitmodules`), repo-root files
  (`install.sh`, `AGENTS.md`, `README.md`), and editor artifacts (vim swap
  `.foo.swp`, backups `foo~`, autosaves `#foo#`).
- `.gitignore` and `.stow-local-ignore` are independent: stow reads the
  **filesystem**, not git. A gitignored-but-present file still gets stowed, so
  don't leave junk physically in the tree.

## Directory policy (real vs whole-dir symlink)

A directory stays **real** when the app writes runtime state or secrets into it
alongside our config. These are pre-created by `install.sh` (keep this list and
`install.sh` in sync):

- `~/.config` — top-level
- `~/.config/fish` — fish_variables
- `~/.config/opencode` — node_modules/, opencode.jsonc
- `~/.claude` — sessions/, history.jsonl, settings.json, caches
- `~/.clojure` / `~/.lein` / `~/.lsp` — caches, self-installs
- `~/.gemini` / `~/.newsboat` — auth / state
- `~/.gnupg` — keys (chmod 700)
- `~/.i3` — generated `config` (from `generate-i3-config`)

Everything else — a dir holding *only* my own static files — folds into a
whole-dir symlink and needs no pre-creation (new files appear automatically).

## Shared agent config (`.agents/`)

`.agents/` is the tool-neutral source of truth for agent components, mirroring
the `skills/` + `commands/` + `agents/` layout both tools use:

- `.agents/skills/<name>/SKILL.md`
- `.agents/commands/<name>.md`
- `.agents/agents/<name>.md`

Each tool's config dir reaches it through **whole-dir** symlinks (committed to
the repo, so `install.sh` reproduces them), which is what makes a newly added
component show up in every tool without extra wiring:

- `.claude/{skills,commands,agents}` → `../.agents/*`
- `.config/opencode/{commands,agents}` → `../../.agents/*`

Never replace these with per-file symlinks — new files would then need linking
by hand. Add new components to `.agents/`, never to a tool's own directory.

To stay portable across both tools, a component must:

- **Skills**: have `name` and `description` frontmatter. Extra keys
  (`argument-hint`, `author`, `metadata`) are tolerated by both.
- **Agents**: have a `name` field. Claude Code silently skips agent files
  without one (opencode infers it from the filename, so this is easy to miss).
  `mode: subagent` is ignored by Claude Code and safe to keep.
- **Both**: avoid provider-specific `model:` pins. Claude Code loads the file
  but the spawn fails with a 404 `model_not_found` (this is why `/cycle` and the
  `cycle-*` agents are opencode-only in practice — they pin
  `opencode/deepseek-v4-pro`). Omit `model:` to inherit each tool's default.

Validate a component directory with `claude plugin validate .agents/skills`.

## Per-tool notes

- **Claude Code**: `~/.claude` stays real (session state); only
  `skills/`, `commands/`, and `agents/` are symlinked in from `.agents/`. The
  repo's `.claude/` doubles as this repo's *project-level* config, so anything
  added there is loaded twice when working in `~/.dotfiles` — user-level and
  project-level components with the same name dedupe, so this is harmless, but
  keep real files out of `.claude/`. There is no per-command disable in Claude
  Code (skills can be toggled in `/skills`; commands cannot), so a shared
  command appears on every machine.
- **fish**: `~/.config/fish/` is co-managed by fisher (`conf.d/`, `functions/`,
  `completions/`, `themes/`, `fish_plugins`). Only `config.fish` and `custom/`
  live here. Don't claim `conf.d/`.
- **kitty / dunst / skhd / sxhkd / parallel**: whole-dir symlinks
  (`~/.config/kitty`, `~/.config/dunst`, `~/.config/skhd`, `~/.config/sxhkd`,
  `~/.parallel`).
- **tmux**: scripts live in `.config/tmux/`; `.tmux.conf` references them by
  repo path `~/.dotfiles/.config/tmux/*.sh`.
- **neovim**: lazy.nvim-based; `.config/nvim/` is a whole-dir symlink. Plugins
  install to `~/.local/share/nvim/lazy/` (not tracked); `lazy-lock.json` is
  gitignored. Plugin list lives in `lua/user/plugins.lua`; legacy Vimscript is
  still sourced from `.config/nvim/vim/*.vim` (not yet converted to Lua).
- **git**: `.gitconfig` is generated by `~/.bin/generate-gitconfig`, not tracked.

## Conventions

- Commit after each meaningful unit of work; review `git diff` before committing.
- Use `git mv` for moves; don't use `git add -A`.
