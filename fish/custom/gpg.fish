set -gx GPG_TTY (tty)

# decrypt encrypted .fish files and source them
function gpg-source
  gpg -d $argv | source
end

# adzerk credentials, useful functions, etc.
function adzerk-env
  if count $argv > /dev/null
    if [ $argv[1] = prod ]
      set -gx ADZERK_ENV prod
    else
      set -gx ADZERK_ENV qa
    end
  else
    set -gx ADZERK_ENV qa
  end

  gpg-source $HOME/.adzerk.fish.asc
end

# other sensitive things i need in my environment
function sensitive-env
  gpg-source $HOME/.sensitive.fish.asc
end
