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
sudo apt install -y \
  curl \
  git-all \
  xsel xclip \
  python3-dev python3-pip \
  rbenv ruby-dev \
  ack-grep silversearcher-ag \
  tmux

################################################################################
# Install fish shell
################################################################################

echo
echo "Installing fish shell..."
echo
sudo apt install -y fish

echo
echo "Making fish the default shell..."
echo
which fish | sudo tee -a /etc/shells
chsh -s "$(which fish)"

################################################################################
# Install jenv
################################################################################

echo
echo "Installing jenv..."
echo
git clone https://github.com/jenv/jenv.git ~/.jenv

################################################################################
# Install Node.js
################################################################################

echo
echo "Installing Node.js..."
echo
curl -fsSL https://deb.nodesource.com/setup_15.x | sudo -E bash -
sudo apt install -y nodejs
npm config set prefix ~/npm

################################################################################
# Install Neovim
################################################################################

echo
echo "Installing Neovim..."
echo

sudo apt install -y software-properties-common
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install -y neovim
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --config vi
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --config vim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
sudo update-alternatives --config editor

python3 -m pip install --user --upgrade pynvim
gem install --user neovim
npm install -g neovim

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
# Install vim-plug
################################################################################

echo
echo "Installing vim-plug..."
echo

sh -c 'curl
         -fLo
         "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
         --create-dirs
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

vim +PlugInstall +qall

################################################################################

# TODO: Install i3

# TODO: Install a terminal emulator? Unclear which one I really want. Right now
# I'm using Roxterm, instructions here:
# https://launchpad.net/~h-realh/+archive/ubuntu/roxterm

################################################################################

echo "Done!"
