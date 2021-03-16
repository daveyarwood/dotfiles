# Setup from README
set -gx ZERKENV_BUCKET zerkenv
set -gx ZERKENV_REGION us-east-1
. (zerkenv -i fish | psub)

# Convenient short alias
alias ze zerkenv
alias zl zerkload

