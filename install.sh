#!/usr/bin/env bash
set -e

# Pre-create "container" directories that must stay real (not symlinked) because
# applications write runtime state or secrets into them. Stow would otherwise
# fold these into whole-dir symlinks, routing app state (fish variables, gnupg
# keys, opencode's node_modules, Claude Code's sessions and history, i3's
# generated config, etc.) into this repo.
mkdir -p \
  ~/.config \
  ~/.config/fish \
  ~/.config/opencode \
  ~/.claude \
  ~/.clojure \
  ~/.newsboat \
  ~/.lein \
  ~/.lsp \
  ~/.i3

mkdir -p ~/.gnupg
chmod 700 ~/.gnupg

cd "$(dirname "$0")"
stow .

# Claude Code reads components only from ~/.claude, and the repo root mirrors
# $HOME — so a tracked .claude/ would double as this repo's *project-level*
# config dir, loading every skill twice while working in ~/.dotfiles (they show
# up twice in /skills). Link them in from the shared .agents/ root instead.
# -n so an existing link is replaced rather than followed into.
for component in skills commands agents; do
  ln -sfn "$PWD/.agents/$component" ~/.claude/"$component"
done

# Same reasoning for the user-level instruction file: ~/.claude/CLAUDE.md is the
# only user-level location Claude Code reads, so the tool-neutral copy in
# .agents/ is linked in rather than tracked at .claude/CLAUDE.md, which would
# double as this repo's project-level instructions and load twice here.
ln -sfn "$PWD/.agents/AGENTS.md" ~/.claude/CLAUDE.md

# OpenCode falls back to ~/.claude/CLAUDE.md for global rules, but it does not
# expand the @conventions.md import inside that file the way Claude Code does.
# .config/opencode/opencode.json lists .agents/conventions.md directly in its
# "instructions" array instead, so OpenCode still gets the global code
# conventions. stow already places that file; nothing to link here.
