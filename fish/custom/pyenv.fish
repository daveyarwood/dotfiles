add-dir-to-path "$HOME/.pyenv/bin"

status --is-interactive; and . (pyenv init -|psub)
status --is-interactive; and . (pyenv virtualenv-init -|psub)

# # Source: https://vi.stackexchange.com/questions/7644/use-vim-with-virtualenv/7654#7654
# if test -n "$VIRTUAL_ENV"; and test -e "$VIRTUAL_ENV"
#   set script "$VIRTUAL_ENV/bin/activate.fish"
#   echo "Sourcing $script..."
#   source "$script"
# end

