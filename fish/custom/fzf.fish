set -l fzf_dir $HOME/.fzf/bin

if test -d $fzf_dir
  set -gx PATH $fzf_dir $PATH
end

set -gx FZF_DEFAULT_COMMAND 'ag --hidden --ignore .git -g ""'
set -gx FZF_DEFAULT_OPTS '--height 60% --reverse --border'

