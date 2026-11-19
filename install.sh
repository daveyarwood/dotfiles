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

# macOS: ~/Library/LaunchAgents holds other apps' agents too, so it stays real
# and stow links our plists into it one by one.
if [[ "$(uname)" == "Darwin" ]]; then
  mkdir -p ~/Library/LaunchAgents
fi

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

# OpenCode reads its global rules from ~/.config/opencode/AGENTS.md and falls
# back to ~/.claude/CLAUDE.md only when that file is absent, so the file has to
# be there rather than merely reachable by fallback. stow will not place it:
# .stow-local-ignore matches AGENTS.md at any depth, not only at the repo root.
ln -sfn "$PWD/.agents/AGENTS.md" ~/.config/opencode/AGENTS.md

# Load our launchd agents. bootout first so a re-run picks up plist changes.
if [[ "$(uname)" == "Darwin" ]]; then
  for plist in Library/LaunchAgents/*.plist; do
    label=$(basename "$plist" .plist)
    launchctl bootout "gui/$(id -u)/$label" 2>/dev/null || true
    launchctl bootstrap "gui/$(id -u)" ~/"$plist"
  done
fi
