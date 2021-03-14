#!/usr/bin/env bash

update_and_upgrade_apt_packages() {
  echo Updating/upgrading apt packages...
  sudo apt update
  sudo apt upgrade
}

install_git() {
  sudo apt install git-all
}

install_curl() {
  sudo apt install curl
}

install_fish_shell() {
  echo Installing fish shell...
  sudo apt install fish

  echo Making fish the default shell...
  which fish | sudo tee -a /etc/shells
  chsh -s "$(which fish)"
}

install_oh_my_fish() {
  echo Installing oh-my-fish...
  curl -L http://get.oh-my.fish | fish
}

install_jenv() {
  git clone https://github.com/gcuisinier/jenv.git ~/.jenv
}

install_rbenv() {
  sudo apt install rbenv
}

install_hub() {
  sudo apt install golang
  cd /tmp
  git clone https://github.com/github/hub.git && cd hub
  script/build -o "$HOME/bin/hub"
}

install_dotfiles() {
  # my dotfiles rely on $CODEDIR and $MUSICDIR being set already, which may not
  # be the case, so we need to set them here if they aren't set
  if [[ -z $CODEDIR ]]; then
    export CODEDIR=$HOME/Code
  fi

  if [[ -z $MUSICDIR ]]; then
    export MUSICDIR=$HOME/Music
  fi

  git clone https://github.com/daveyarwood/dotfiles.git "$HOME/.dotfiles"
  cd .dotfiles
  ./install
}

install_neovim() {
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
}

install_vim-plug() {
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim +PlugInstall +qall
}

install_ack() {
  sudo apt install ack-grep
}

install_tmux() {
  sudo apt install tmux
}

install_ag() {
  sudo apt install silversearcher-ag
}

update_and_upgrade_apt_packages
sudo apt install xsel xclip

install_git
install_curl
install_ack
install_ag
install_tmux
install_fish_shell
install_oh_my_fish
install_jenv
install_rbenv
install_hub
install_dotfiles
install_neovim
install_vim-plug

echo "Done!"
