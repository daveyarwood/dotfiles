set fish_runtime $HOME/.config/fish

# Default PATH
set -gx PATH $HOME/bin $HOME/.bin /usr/local/bin /usr/local/sbin /usr/bin /bin /usr/sbin /sbin /usr/games

# Adds a directory to PATH, but only if the directory exists.
function add-dir-to-path
  set dir $argv[1]
  if test -d $dir
    set -gx PATH $dir $PATH
  end
end

function add-dirs-to-path
  for dir in $argv
    add-dir-to-path $dir
  end
end

add-dirs-to-path /opt/X11/bin $HOME/.local/bin /snap/bin

# hardcoded paths to directories on my Thinkpad
# TODO: come up with some way to have different paths on different hosts
set -q CODEDIR; or set -gx CODEDIR $HOME/code
set -q MUSICDIR; or set -gx MUSICDIR $HOME/Music/Dave\'s\ Music\ Library

# git shortcuts (ga = git add, etc.)
source $fish_runtime/custom/git.fish

# misc configs (adding dirs to $PATH, etc.)
source $fish_runtime/custom/rbenv.fish
source $fish_runtime/custom/pyenv.fish
source $fish_runtime/custom/jenv.fish
source $fish_runtime/custom/postgres.fish
# source $fish_runtime/custom/docker.fish
source $fish_runtime/custom/clojure.fish
source $fish_runtime/custom/clojurescript.fish
source $fish_runtime/custom/haskell.fish
source $fish_runtime/custom/tex.fish
source $fish_runtime/custom/lilypond.fish
source $fish_runtime/custom/android.fish
source $fish_runtime/custom/vim.fish
source $fish_runtime/custom/go.fish
source $fish_runtime/custom/beets.fish
source $fish_runtime/custom/php.fish
source $fish_runtime/custom/pony.fish
source $fish_runtime/custom/carp.fish
source $fish_runtime/custom/erlang.fish
source $fish_runtime/custom/sdk.fish
source $fish_runtime/custom/ocaml.fish
source $fish_runtime/custom/rust.fish
source $fish_runtime/custom/ssh.fish
source $fish_runtime/custom/ruby.fish
source $fish_runtime/custom/kevel.fish
source $fish_runtime/custom/fzf.fish
source $fish_runtime/custom/sql.fish
source $fish_runtime/custom/dart.fish
source $fish_runtime/custom/perl.fish
source $fish_runtime/custom/zerkenv.fish
source $fish_runtime/custom/lenv.fish
source $fish_runtime/custom/task.fish
source $fish_runtime/custom/io.fish
source $fish_runtime/custom/node.fish
source $fish_runtime/custom/gpg.fish
source $fish_runtime/custom/i3.fish
source $fish_runtime/custom/relpipe.fish

# useful shell functions
source $fish_runtime/custom/functions.fish

# fish ascii art
source $fish_runtime/custom/fish_logo.fish
source $fish_runtime/custom/fish_swimming.fish

source $fish_runtime/custom/theme.fish

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
