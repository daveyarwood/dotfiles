# Prevent apt commands (e.g. `apt list --upgradable`) from dropping me into
# a pager, which is annoying for scripting / non-interactive use cases.
set -gx APT_PAGER ""
