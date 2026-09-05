#!/usr/bin/env bash
set -e

# Pre-create "container" directories that must stay real (not symlinked) because
# applications write runtime state or secrets into them. Stow would otherwise
# fold these into whole-dir symlinks, routing app state (fish variables, gnupg
# keys, opencode's node_modules, i3's generated config, etc.) into this repo.
mkdir -p \
  ~/.config \
  ~/.config/fish \
  ~/.config/opencode \
  ~/.clojure \
  ~/.gemini \
  ~/.newsboat \
  ~/.lein \
  ~/.lsp \
  ~/.i3

mkdir -p ~/.gnupg
chmod 700 ~/.gnupg

cd "$(dirname "$0")"
stow .
