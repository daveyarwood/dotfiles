#!/usr/bin/env bash

set -eo pipefail

################################################################################
# Install misc. apt packages
################################################################################

echo "Updating/upgrading existing apt packages..."
echo
sudo apt update
sudo apt upgrade

echo
echo "Installing various apt packages..."
echo
sudo apt install \
  curl \
  git-all \
  xsel xclip \
  rbenv \
  ack-grep silversearcher-ag \
  tmux

################################################################################
# Install fish shell
################################################################################

echo
echo "Installing fish shell..."
echo
sudo apt install fish

echo
echo "Making fish the default shell..."
echo
which fish | sudo tee -a /etc/shells
chsh -s "$(which fish)"

# TODO: Look into what (if anything) I need OMF for and either don't use a fish
# shell package manager at all, or switch to a newer/maintained one.
echo
echo "Installing oh-my-fish..."
echo
curl -L http://get.oh-my.fish | fish

################################################################################
# Install jenv
################################################################################

echo
echo "Installing jenv..."
echo
git clone https://github.com/gcuisinier/jenv.git ~/.jenv

################################################################################
# Install hub
################################################################################

echo
echo "Installing hub..."
echo

sudo apt install golang
cd /tmp
git clone https://github.com/github/hub.git && cd hub
script/build -o "$HOME/bin/hub"

################################################################################
# Install Neovim
################################################################################

echo
echo "Installing Neovim..."
echo

sudo apt install software-properties-common
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim
sudo apt install python-dev python-pip python3-dev python3-pip
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --config vi
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --config vim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
sudo update-alternatives --config editor

################################################################################
# Install vim-plug
################################################################################

echo
echo "Installing vim-plug..."
echo

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall

################################################################################
# Install dotfiles
################################################################################

echo
echo "Installing dotfiles..."
echo

# my dotfiles rely on $CODEDIR and $MUSICDIR being set already, which may not
# be the case, so we need to set them here if they aren't set
if [[ -z $CODEDIR ]]; then
  export CODEDIR=$HOME/Code
fi

if [[ -z $MUSICDIR ]]; then
  export MUSICDIR=$HOME/Music
fi

git clone https://github.com/daveyarwood/dotfiles.git "$HOME/.dotfiles"
cd "$HOME/.dotfiles"
./install

################################################################################

# TODO: Install i3

# TODO: Install a terminal emulator? Unclear which one I really want. Right now
# I'm using Roxterm, instructions here:
# https://launchpad.net/~h-realh/+archive/ubuntu/roxterm

################################################################################

echo "Done!"
