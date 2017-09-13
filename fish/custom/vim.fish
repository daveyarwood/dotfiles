set -gx EDITOR nvim

# use neovim by default
balias vim nvim
# oldvim starts literal vim
balias oldvim /usr/local/bin/vim

# edit vimrc
balias vimrc "vim $HOME/.vimrc"

# bring up a scratch buffer
balias vims "vim /tmp/scratch"

balias vimwiki "vim $HOME/Dropbox/vimwiki/index.wiki"
balias vw vimwiki

# alias vc = vimcat (cats what a file looks like in vim)
balias vc vimcat

balias vf "vim (fzf)"

# update Vundle plugins
function updatevim
  set -lx SHELL (which sh)
  vim +BundleInstall! +BundleClean +qall
end

