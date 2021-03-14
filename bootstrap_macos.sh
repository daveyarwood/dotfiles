#!/usr/bin/env bash

# PSA: This is basically unmaintained since 2017, when I switched back to Linux.
#
# It's unlikely that I'll ever boostrap another Mac for software development,
# but if I ever do, I should revisit what this script does, compare it to what
# bootstrap_ubuntu.sh does, and make updates.

install_homebrew() {
  echo Installing Homebrew...
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

install_git() {
  # git should already be installed;
  # running git for the first time will install xcode cli tools if needed
  git
}

install_fish_shell() {
  echo Installing fish shell...
  brew install fish

  echo Making fish the default shell...
  # This part is probably Linux specific.
  # which fish | sudo tee -a /etc/shells
  chsh -s "$(which fish)"
}

install_oh_my_fish() {
  echo Installing oh-my-fish...
  curl -L http://get.oh-my.fish | fish
}

install_jenv() {
  brew install jenv
}

install_rbenv() {
  brew install rbenv
}

install_hub() {
  brew install hub
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
  brew install neovim/neovim/neovim
}

install_vim-plug() {
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim +PlugInstall +qall
}

install_ack() {
  brew install ack
}

install_tmux() {
  brew install tmux
}

install_ag() {
  brew install the_silver_searcher
}

install_homebrew
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
