set -gx EDITOR nvim

# Use Neovim by default.
# NB: The --wraps part is a workaround for an issue with fish where it doesn't
# do tab completion on filenames when using an alias.
# See: https://github.com/fish-shell/fish-shell/issues/2277
function vim --wraps nvim
  # HACK: there was a regression between the Linux kernel and fzf that makes
  # vim-fzf not work properly for me; I get the error message "Failed to read
  # /dev/tty" when I run `:FZF`.
  #
  # See: https://github.com/junegunn/fzf/issues/1486
  #
  # The issue is fixed for me when I have SHELL set to bash, and it doesn't seem
  # to affect the rest of my vim experience; in fact, I've had `set shell=bash`
  # in my vimrc for ages, so I think that's the behavior I want.
  #
  # So, working around this by always opening vim with SHELL set to bash.
  env SHELL=bash nvim $argv
end

alias v "vim"
alias v. "vim ."
alias vi. "vim ."
alias vim. "vim ."

# edit vimrc
alias vimrc "vim $HOME/.vimrc"

# Edit a scratch file with the given extension (default: adoc)
function vims
  set -l ext "adoc"

  if test (count $argv) -gt 0
    set ext $argv[1]
  end

  vim /tmp/scratch-(date '+%Y%m%d%H%M%S').$ext
end

alias vimwiki "vim $HOME/Sync/vimwiki/index.wiki"
alias vw vimwiki

alias vf "vim (fzf)"
alias vr "vim (git ls-files | shuf -n1)"

function vr
  if test (count $argv) -eq 0
    vim (git ls-files | shuf -n1)
  else
    set -l filter $argv[1]
    vim (git ls-files | grep $filter | shuf -n1)
  end
end

alias vpi 'vim +PlugInstall /dev/null'
alias vpu 'vim +PlugUpdate /dev/null'

# mnemonic: vim grep
function vg
  vim "+CtrlSF $argv" /dev/null
end

