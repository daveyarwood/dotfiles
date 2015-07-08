##### oh-my-fish #####

# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish

# Path to your custom folder (default path is ~/.oh-my-fish/custom)
set fish_custom $HOME/dotfiles/oh-my-fish

# Load oh-my-fish configuration.
source $fish_path/oh-my-fish.fish

# Custom plugins and themes may be added to ~/.oh-my-fish/custom
# Plugins and themes can be found at https://github.com/oh-my-fish/
Theme 'tomita'
Plugin 'theme'
Plugin 'balias'
Plugin 'jump'
Plugin 'msg'
Plugin 'tab'
Plugin 'vi-mode'

# Default PATH
set -gx PATH /usr/local/bin /usr/local/sbin /usr/bin /bin /usr/sbin /sbin /opt/X11/bin

##### git shortcuts #####

balias git hub
balias g git
balias gs 'git status'
balias gc 'git commit'
balias gco 'git checkout'
function ga; git add $argv; git status; end
balias gl "git log --graph --pretty=format:\"%C(yellow)%h %ad%Cred%d %Creset%s%Cblue [%cn]\" --decorate --all --date=short"
balias gd 'git diff'
balias gp 'git push'
balias gpr 'git pull-request'

##### rbenv #####

set -gx RBENV_ROOT /usr/local/var/rbenv
source (rbenv init -|psub)

##### jenv #####

set -gx PATH $HOME/.jenv/bin $PATH

##### heroku #####

set -gx PATH /usr/local/heroku/bin $PATH

##### postgres #####

set -gx PATH $PATH /Applications/Postgres.app/Contents/Versions/9.3/bin

##### docker #####

# this allows me to use `$(boot2docker ip)` inside commands without
# "The VM's Host only interface IP address is:" printing to STDOUT
function docker-ip
  boot2docker ip ^ /dev/null
end

##### clojurescript #####

set -gx CLOJURESCRIPT_HOME /Users/dave/Code/clojurescript
set -gx PATH $CLOJURESCRIPT_HOME/bin $PATH

##### haskell #####

# Add GHC 7.8.4 to the PATH, via http://ghcformacosx.github.io/
set -gx GHC_DOT_APP /Applications/ghc-7.8.4.app
if test -d $GHC_DOT_APP
    set -gx PATH $HOME/.cabal/bin $GHC_DOT_APP/Contents/bin $PATH
end

