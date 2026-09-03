# pnpm keeps its global bin dir under a platform-specific home directory, and
# needs PNPM_HOME pointed at it to install global packages there.
if test -d $HOME/Library/pnpm
  set -gx PNPM_HOME $HOME/Library/pnpm
else
  set -gx PNPM_HOME $HOME/.local/share/pnpm
end

add-dirs-to-path $HOME/npm/bin $HOME/.yarn/bin $PNPM_HOME/bin

# ~/.npmrc expands $NODE_AUTH_TOKEN to authenticate against private GitHub
# Packages registries. Read it from gh on each shell rather than storing a copy,
# so it stays current when gh rotates the token.
if command -v gh >/dev/null
  set -gx NODE_AUTH_TOKEN (gh auth token 2>/dev/null)
end

# Automatically run `nvm use` upon entering a directory that specifies a Node
# version via a `.nvmrc` or `.node-version` file, or that has an ancestor
# directory that does.
#
# `nvm use` with no version looks up the nearest such file itself, so all we
# need to do is confirm there is one; otherwise it would print an error every
# time we cd anywhere else. We can't use nvm's own `_nvm_find_up` helper for
# that, because it's defined inside `nvm.fish` and isn't autoloadable.
#
# Relevant discussions and code snippets:
# https://github.com/jorgebucaran/nvm.fish/issues/132
# https://github.com/jorgebucaran/nvm.fish/pull/186
function use-the-right-node-version --on-variable PWD
  set --local dir $PWD

  while test -n "$dir"
    if test -r $dir/.nvmrc || test -r $dir/.node-version
      # nvm_current_version is an exported variable, so it can be inherited by
      # a shell that doesn't have the corresponding nvm bin dir in its PATH
      # (e.g. a new tmux pane). When that happens, `nvm use` short-circuits on
      # its `$ver != $nvm_current_version` check and we're left with the
      # Homebrew node. Erase the stale value so that `nvm use` actually
      # prepends nvm's bin dir to PATH in this shell.
      #
      # (We only do this when the value is stale; erasing it unconditionally
      # would make every `cd` prepend another copy of the bin dir to PATH.)
      if set --query nvm_current_version
        and not contains -- $nvm_data/$nvm_current_version/bin $PATH
        set --erase nvm_current_version
      end

      nvm use --silent
      return
    end

    set dir (string replace --regex -- '/[^/]*$' '' $dir)
  end
end

use-the-right-node-version
