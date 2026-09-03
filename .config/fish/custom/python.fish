set -gx PYENV_ROOT "$HOME/.pyenv"

# Homebrew's pyenv lives on the PATH already, but a git-cloned one wouldn't,
# and either way this is where pyenv keeps the versions it installs.
add-dirs-to-path "$PYENV_ROOT/bin"

if command -v pyenv >/dev/null
  # `pyenv init -` sniffs the shell from the parent process; naming fish
  # explicitly keeps it from guessing wrong (e.g. when run from a subshell).
  pyenv init - fish | source
end
