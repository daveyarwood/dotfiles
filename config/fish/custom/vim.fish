set -gx EDITOR nvim

# use neovim by default
function vim
	nvim $argv;
end

# oldvim starts literal vim
function oldvim
	/usr/local/bin/vim $argv;
end

# edit vimrc
function vimrc
	vim $HOME/.vimrc $argv;
end

# bring up a scratch buffer
function vims
	vim /tmp/scratch $argv;
end

function vimwiki
	vim $HOME/Dropbox/vimwiki/index.wiki $argv;
end

function vw
	vimwiki $argv;
end

# alias vc = vimcat (cats what a file looks like in vim)
function vc
	vimcat $argv;
end

# update Vundle plugins
function updatevim
  set -lx SHELL (which sh)
  vim +BundleInstall! +BundleClean +qall
end

