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
source $fish_runtime/custom/beets.fish

# useful shell functions
source $fish_runtime/custom/functions.fish

# fish ascii art
source $fish_runtime/custom/fish_logo.fish
source $fish_runtime/custom/fish_swimming.fish

function fish_greeting;
  fish_logo
end

# erase the default fish_mode_prompt; I have one built into my theme
function fish_mode_prompt; end

# turn on vi mode on shell start
fish_vi_mode

# vi mode remaps Ctrl-F to go forward a word;
# I'd rather keep the default behavior of accepting autocomplete suggestions
#
# also Ctrl-A and Ctrl-E don't do anything anymore... let's get those back
function fish_slightly_modified_vi_key_bindings
  fish_vi_key_bindings
  bind -M insert \cf end-of-line
  bind -M insert \ca beginning-of-line
  bind -M insert \ce end-of-line
end

set fish_key_bindings fish_slightly_modified_vi_key_bindings

# for x in (seq 20)
#     msg @random:random $big_fish
# end
set -gx big_fish "><(((('>"
set -gx little_fish '⋊>'

# decrypt and run encrypted .fish files (sensitive credentials, etc.)
source $fish_runtime/custom/gpg.fish

