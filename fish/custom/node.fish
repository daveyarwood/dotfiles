add-dirs-to-path $HOME/npm/bin $HOME/.yarn/bin

# Hacky workaround to automatically switch to Node 18 when entering this
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
  if test $PWD = "$HOME/code/spark"
    nvm use 18
  end
end

use-the-right-node-version
