# TODO: Remove this entirely once I'm done using moondog.

# Setup from README
set -gx ZERKENV_BUCKET zerkenv
set -gx ZERKENV_REGION us-east-1
if test (hostname) = moondog
  . (zerkenv -i fish | psub)
end

# Convenient short alias
alias ze zerkenv
alias zl zerkload

