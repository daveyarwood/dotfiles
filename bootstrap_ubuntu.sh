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
  htop \
  python3-dev python3-pip \
  rbenv ruby-dev \
  ack-grep silversearcher-ag \
  tmux \
  i3 light rofi feh \
  libsecret-1-0 libsecret-1-dev \
  tlp tlp-rdw acpi-call-dkms \
  taskwarrior \
  kitty

################################################################################
# Install libsecret
################################################################################

# Reference: https://www.softwaredeveloper.blog/git-credential-storage-libsecret

cd /usr/share/doc/git/contrib/credential/libsecret
sudo make

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
# Install pyenv
################################################################################

echo
echo "Installing pyenv..."
echo

git clone \
  https://github.com/pyenv/pyenv.git \
  ~/.pyenv

git clone \
  https://github.com/pyenv/pyenv-virtualenv.git \
  ~/.pyenv/plugins/pyenv-virtualenv

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
# Install Go
################################################################################

# Reference: https://golang.org/doc/install

# 2021-03-20: At the time of writing, I want to use at least Go 1.15.3 because
# that's what I've been using for developing Alda. In general, I like to update
# to a newer version periodically whenever I have time to verify it won't break
# something. While I'm in here writing out the manual steps, I figured I might
# as well update to the latest version, which is 1.16.2.
#
# TODO: Consider updating again whenever I run this bootstrap script again in
# the future.
go_version="1.16.2"
go_tarball="go$go_version.linux-amd64.tar.gz"
download_url="https://golang.org/dl/$go_tarball"

pushd /tmp > /dev/null
curl -Lo "$go_tarball" "$download_url"
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "$go_tarball"
popd > /dev/null

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

# Install various Ruby gems required by scripts I use in my shell config, etc.
gem install --user colorize dotiw

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
# Install i3
################################################################################

echo
echo "Setting i3 as the default window manager..."
echo

sudo update-alternatives --install /usr/bin/x-session-manager x-session-manager /usr/bin/i3 60
sudo update-alternatives --config x-session-manager

# Necessary in order for the `light` program (which manages brightness; I have
# key bindings set up so that my brightness up/down keys invoke `light`) to be
# run without sudo.
sudo usermod -a -G video $USER
echo "NOTE: You'll need to restart in order for brightness keys to work."

################################################################################
# Set kitty as default terminal
################################################################################

echo
echo "Choose default terminal (e.g. kitty):"
echo
sudo update-alternatives --config x-terminal-emulator

echo
echo "Done!"