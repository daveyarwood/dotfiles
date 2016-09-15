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

update_and_upgrade_apt_get_packages() {
  echo Updating/upgrading apt-get packages...
  sudo apt-get update
  sudo apt-get upgrade
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
    sudo apt-get install git-all
  fi
}

install_dotfiles() {
  cd $HOME
  git clone https://github.com/daveyarwood/dotfiles.git .dotfiles
  cd .dotfiles
  ./install
}

install_fish_shell() {
  echo Installing fish shell...

  if [[ $platform == osx ]]; then
    brew install fish
  elif [[ $os == ubuntu ]]; then
    sudo apt-add-repository ppa:fish-shell/release-2
    sudo apt-get update
    sudo apt-get install fish
  fi

  echo Making fish the default shell...
  chsh -s /usr/local/bin/fish
}

install_oh_my_fish() {
  echo Installing oh-my-fish...
  curl -L http://get.oh-my.fish | fish
}

if [[ $platform == osx ]]; then
  install_homebrew
fi

if [[ $os == ubuntu ]]; then
  update_and_upgrade_apt_get_packages
fi

install_git
install_dotfiles
install_fish_shell
install_oh_my_fish
