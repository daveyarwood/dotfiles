set -gx GPG_TTY (tty)

# decrypt encrypted .fish files and source them
function gpg-source
  gpg -d $argv | source
end

# sensitive things i need in my environment
function sensitive-env
  gpg-source $HOME/.sensitive.fish.asc
end
