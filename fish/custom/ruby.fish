set -gx RBENV_ROOT "$HOME/.rbenv"

add-dirs-to-path \
  "$RBENV_ROOT/bin" \
  "$RBENV_ROOT/plugins/ruby-build/bin" \
  "$HOME/.local/share/gem/ruby/3.0.0/bin"

if command -v rbenv >/dev/null
  rbenv init - | source
end
