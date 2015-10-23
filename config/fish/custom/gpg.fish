# decrypt encrypted .fish files and source them
function gpg-source
  gpg -d $argv | source
end

# adzerk credentials, useful functions, etc.
function adzerk-env
  gpg-source ~/.adzerk.fish.asc
end

# other sensitive things i need in my environment
function sensitive-env
  gpg-source ~/.sensitive.fish.asc
end
