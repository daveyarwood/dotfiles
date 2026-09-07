# SSH agent
#
# Use OpenSSH's socket-activated agent (systemd user ssh-agent.socket), which
# listens at $XDG_RUNTIME_DIR/openssh_agent and is shared by every shell. Add
# the key once; ssh-add skips keys that are already loaded, so this only
# prompts for the passphrase on the first shell after login.

set -q XDG_RUNTIME_DIR; or set -gx XDG_RUNTIME_DIR "/run/user/(id -u)"
set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/openssh_agent"

ssh-add ~/.ssh/id_rsa >/dev/null 2>&1
