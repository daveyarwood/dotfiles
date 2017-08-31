# Path to Oh My Fish install.
set -gx OMF_PATH $HOME/.local/share/omf

source $OMF_PATH/init.fish

set fish_runtime $HOME/.config/fish

# Default PATH
set -gx PATH $HOME/bin $HOME/.bin /usr/local/bin /usr/local/sbin /usr/bin /bin /usr/sbin /sbin

# add these folders to PATH if they exist
for dir in /opt/X11/bin $HOME/.local/bin
  if test -d $dir
    set -gx PATH $dir $PATH
  end
end

# hardcoded paths to directories on my Macbook
# TODO: come up with some way to have different paths on different hosts
set -q $CODEDIR; or set -gx CODEDIR $HOME/Code
set -q $MUSICDIR; or set -gx MUSICDIR $HOME/Music/Dave\'s\ Music\ Library

# git shortcuts (ga = git add, etc.)
source $fish_runtime/custom/git.fish

# misc configs (adding dirs to $PATH, etc.)
source $fish_runtime/custom/rbenv.fish
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
source $fish_runtime/custom/mono.fish
source $fish_runtime/custom/rust.fish
source $fish_runtime/custom/ssh.fish
source $fish_runtime/custom/ruby.fish
source $fish_runtime/custom/adzerk.fish
source $fish_runtime/custom/fzf.fish

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

