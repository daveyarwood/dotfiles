# AGENTS.md (user-level)

Cross-cutting working rules for AI agents, on every project on this machine.

**Not to be confused with `~/.dotfiles/AGENTS.md`**, one directory up, which is
rules for working *on the dotfiles repo*. This file is rules for working on
*anything*.

**Keep this file small.** It loads into every session on every project, whether
or not it is relevant, which is the same ambient-context cost that makes a
skill preferable to an MCP server. Only genuinely cross-cutting preferences
belong here. Anything project-specific goes in that project's own `AGENTS.md`.

Both tools reach this file as their user-level instruction file: Claude Code as
`~/.claude/CLAUDE.md` and OpenCode as `~/.config/opencode/AGENTS.md`. Both are
links created by `install.sh`, the first because a tracked `.claude/` would
double as this repo's own project-level config, the second because
`.stow-local-ignore` matches `AGENTS.md` at any depth.

## Code conventions

@conventions.md

That covers language, style and testing, the same in every repo. Claude Code
expands the import above at session start. OpenCode does not expand
`@`-imports, so `.config/opencode/opencode.json` names `.agents/conventions.md`
in its `instructions` array instead. Both routes end at the one file, and
neither tool reads it twice.

**This repo is public.** Nothing private goes in this file: no compensation, no
candid notes about people, no employer-internal detail, no secrets. That is a
real hazard rather than a theoretical one, because a global instruction file is
exactly where a personal preference or a "remember this" fact wants to be
written, and here that means publishing it. Private material belongs in the
project that owns it, behind whatever rules that project sets.

## Git and GitHub

- **No agent attribution.** Do not add a `Co-Authored-By` trailer naming Claude
  or any other model to a commit, and do not append a "Generated with Claude
  Code" line to a pull request description. If a harness supplies attribution
  boilerplate as a default, this overrides it. The commits are mine.
