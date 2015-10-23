# on start-up, start tmux or attach to an existing session
tmux attach; or tmux new -s default

##### oh-my-fish #####

# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish

# Path to your custom folder (default path is ~/.oh-my-fish/custom)
# set fish_custom $HOME/.dotfiles/oh-my-fish

set fish_runtime $HOME/.config/fish

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

# git shortcuts (ga = git add, etc.)
source $fish_runtime/custom/git.fish

# misc configs (adding dirs to $PATH, etc.)
source $fish_runtime/custom/rbenv.fish
source $fish_runtime/custom/jenv.fish
source $fish_runtime/custom/heroku.fish
source $fish_runtime/custom/postgres.fish
source $fish_runtime/custom/docker.fish
source $fish_runtime/custom/clojure.fish
source $fish_runtime/custom/clojurescript.fish
source $fish_runtime/custom/haskell.fish
source $fish_runtime/custom/tex.fish
source $fish_runtime/custom/lilypond.fish
source $fish_runtime/custom/android.fish
source $fish_runtime/custom/vim.fish

# useful shell functions
source $fish_runtime/custom/functions.fish

# show fish ascii art on start
source $fish_runtime/custom/fish_logo.fish

# for x in (seq 20)
#     msg @random:random $feesh
# end
set -gx feesh "><(((('>"

# decrypt and run encrypted .fish files (sensitive credentials, etc.)
source $fish_runtime/custom/gpg.fish
