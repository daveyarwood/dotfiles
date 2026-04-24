add-dirs-to-path $HOME/npm/bin $HOME/.yarn/bin

# Hacky workaround to automatically switch to Node 22 when entering this
# particular project.
#
# This could easily be extended to automatically run `nvm use` when entering any
# directory that has a `.nvmrc` or `.node-version` file. But I don't have that
# exact use case right now, so I'm punting.
#
# Relevant discussions and code snippets:
# https://github.com/jorgebucaran/nvm.fish/issues/132
# https://github.com/jorgebucaran/nvm.fish/pull/186
function use-the-right-node-version --on-variable PWD
  if test $PWD = "$HOME/code/spark" || test $PWD = "$HOME/code/spark-copy"
    # Erase any inherited nvm_current_version so that `nvm use` does not
    # short-circuit on the `$ver != $nvm_current_version` check and actually
    # prepends nvm's bin dir to PATH in this shell. Without this, a pane whose
    # parent shell had already activated Node 22 will see nvm_current_version
    # set but no nvm bin dir in PATH, so `node` falls back to the Homebrew one.
    set --erase nvm_current_version
    nvm use --silent 22.16.0
  end
end

use-the-right-node-version
