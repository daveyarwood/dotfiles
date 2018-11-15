set -gx EDITOR nvim

# Use Neovim by default.
# NB: The --wraps part is a workaround for an issue with fish where it doesn't
# do tab completion on filenames when using an alias.
# See: https://github.com/fish-shell/fish-shell/issues/2277
function vim --wraps nvim
  nvim $argv
end

# oldvim starts literal vim
function oldvim --wraps vim
  /usr/bin/vim $argv
end

# edit vimrc
balias vimrc "vim $HOME/.vimrc"

# bring up a scratch buffer
balias vims "vim /tmp/scratch"

balias vimwiki "vim $HOME/Sync/vimwiki/index.wiki"
balias vw vimwiki

# alias vc = vimcat (cats what a file looks like in vim)
balias vc vimcat

balias vf "vim (fzf)"

balias vcal 'vim +Cal /dev/null'
