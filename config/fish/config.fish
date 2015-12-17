# Path to Oh My Fish install.
set -gx OMF_PATH $HOME/.local/share/omf

source $OMF_PATH/init.fish

set fish_runtime $HOME/.config/fish

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
source $fish_runtime/custom/go.fish

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
