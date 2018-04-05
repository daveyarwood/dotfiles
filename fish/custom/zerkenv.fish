# Setup from README
set -gx ZERKENV_BUCKET zerkenv
set -gx ZERKENV_REGION us-east-1
. (zerkenv -i fish | psub)

# Convenient short alias
balias ze zerkenv
balias zl zerkload

