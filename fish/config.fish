set fish_runtime $HOME/.config/fish

# Default PATH
set -gx PATH $HOME/bin $HOME/.bin /usr/local/bin /usr/local/sbin /usr/bin /bin /usr/sbin /sbin /usr/games

# Adds directories to PATH, but only if the directories exist.
function add-dirs-to-path
  for dir in $argv
    if test -d $dir
      set -gx PATH $dir $PATH
    end
  end
end

add-dirs-to-path /opt/X11/bin $HOME/.local/bin /snap/bin

# hardcoded paths to directories on my Thinkpad
# TODO: come up with some way to have different paths on different hosts
set -q CODEDIR; or set -gx CODEDIR $HOME/code

ls "$fish_runtime/custom" | while read fish_file
  source "$fish_runtime/custom/$fish_file"
end

# vi mode remaps Ctrl-F to go forward a word, and also apparently remaps Ctrl-A
# and Ctrl-E for some purpose.
#
# Let's get those back.
function fish_user_key_bindings
  for mode in insert default visual
    bind -M $mode \cf forward-char
    bind -M $mode \ca beginning-of-line
    bind -M $mode \ce end-of-line
  end
end

# Enable vi mode. (I think this is actually persistent? But any rate, I at least
# need to run it once when bootstrapping a new machine with my dotfiles.)
fish_vi_key_bindings
