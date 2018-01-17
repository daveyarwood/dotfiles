add-dir-to-path $HOME/.fzf/bin

set -gx FZF_DEFAULT_COMMAND 'ag --hidden --ignore .git -g ""'
set -gx FZF_DEFAULT_OPTS '--height 60% --reverse --border'

