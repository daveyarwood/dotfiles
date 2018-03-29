# Setup from README
set -gx ZERKENV_BUCKET zerkenv
. (zerkenv -i fish | psub)

# Convenient short alias
balias ze zerkenv
balias zl zerkload

