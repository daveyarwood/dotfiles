#!/bin/bash

if [[ "$(uname)" == "Darwin" ]]; then
  platform='osx'
elif [[ "$(uname)" == "Linux" ]]; then
  platform='linux'
  if [ "$(python -mplatform | grep Ubuntu)" ]; then
    os='ubuntu'
  else
    "Unsupported OS: $(python -mplatform)"
    exit 1
  fi
else
  echo "Unsupported platform: $(uname)"
  exit 1
fi

update_and_upgrade_apt_packages() {
  echo Updating/upgrading apt packages...
  sudo apt update
  sudo apt upgrade
}

install_homebrew() {
  echo Installing Homebrew...
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

install_git() {
  if [[ $platform == osx ]]; then
    # git should already be installed;
    # running git for the first time will install xcode cli tools if needed
    git
  elif [[ $os == ubuntu ]]; then
    sudo apt install git-all
  fi
}

install_curl() {
  if [[ $os == ubuntu ]]; then
    sudo apt install curl
  fi
}

install_fish_shell() {
  echo Installing fish shell...

  if [[ $platform == osx ]]; then
    brew install fish
  elif [[ $os == ubuntu ]]; then
    sudo apt-add-repository ppa:fish-shell/release-2
    sudo apt update
    sudo apt install fish
  fi

  echo Making fish the default shell...
  chsh -s $(which fish)
}

install_oh_my_fish() {
  echo Installing oh-my-fish...
  curl -L http://get.oh-my.fish | fish
}

install_jenv() {
  if [[ $platform == osx ]]; then
    brew install jenv
  elif [[ $os == ubuntu ]]; then
    git clone https://github.com/gcuisinier/jenv.git ~/.jenv
  fi
}

install_rbenv() {
  if [[ $platform == osx ]]; then
    brew install rbenv
  elif [[ $os == ubuntu ]]; then
    sudo apt install rbenv
  fi
}

install_hub() {
  if [[ $platform == osx ]]; then
    brew install hub
  elif [[ $os == ubuntu ]]; then
    sudo apt install golang
    cd /tmp
    git clone https://github.com/github/hub.git && cd hub
    script/build -o $HOME/bin/hub
  fi
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
  if [[ $platform == osx ]]; then
    brew install neovim/neovim/neovim
  elif [[ $os == ubuntu ]];  then
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
  fi
}

install_vim-plug() {
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim +PlugInstall +qall
}

install_ack() {
  if [[ $platform == osx ]]; then
    brew install ack
  elif [[ $os == ubuntu ]]; then
    sudo apt install ack-grep
  fi
}

install_ag() {
  if [[ $platform == osx ]]; then
    brew install the_silver_searcher
  elif [[ $os == ubuntu ]]; then
    sudo apt install silversearcher-ag
  fi
}

if [[ $platform == osx ]]; then
  install_homebrew
fi

if [[ $os == ubuntu ]]; then
  update_and_upgrade_apt_packages
  sudo apt install xsel
fi

install_git
install_curl
install_ack
install_ag
install_fish_shell
install_oh_my_fish
install_jenv
install_rbenv
install_hub
install_dotfiles
install_neovim
install_vim-plug

echo "Done!"
