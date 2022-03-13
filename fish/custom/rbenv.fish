if test (uname) = Darwin
  set -gx RBENV_ROOT /usr/local/var/rbenv
else
  set -gx RBENV_ROOT $HOME/.rbenv
end

add-dirs-to-path $RBENV_ROOT/bin

rbenv init - | source
