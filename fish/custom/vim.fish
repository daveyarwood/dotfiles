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

balias v "vim"
balias v. "vim ."
balias vi. "vim ."
balias vim. "vim ."

# edit vimrc
balias vimrc "vim $HOME/.vimrc"

# Edit a scratch asciidoc file.
balias vims "vim /tmp/scratch-(date '+%Y%m%d%H%M%S').adoc"

balias vimwiki "vim $HOME/Sync/vimwiki/index.wiki"
balias vw vimwiki

balias vf "vim (fzf)"

balias vcal 'vim +Cal /dev/null'

balias vpi 'vim +PlugInstall /dev/null'
balias vpu 'vim +PlugUpdate /dev/null'

# mnemonic: vim grep
function vg
  # This isn't perfect because a double quote in the search term terminates the
  # string early. That should be pretty rare, though, and if I get it wrong,
  # I can just do :CtrlSF '"whatever"' inside Vim, where I have more control.
  vim '+CtrlSF "'$argv[1]'"' /dev/null
end

