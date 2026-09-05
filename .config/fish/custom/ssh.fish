# SSH agent

function ssh-init
  # Use an agent already present in the environment (e.g. macOS launchd).
  # Otherwise, on Linux with systemd, point at OpenSSH's socket-activated
  # agent, which listens at $XDG_RUNTIME_DIR/openssh_agent.
  if not ssh-add -l >/dev/null 2>&1
    set -q XDG_RUNTIME_DIR; or set -gx XDG_RUNTIME_DIR "/run/user/(id -u)"
    set -l sock "$XDG_RUNTIME_DIR/openssh_agent"
    if test -S "$sock"
      set -gx SSH_AUTH_SOCK "$sock"
    end
  end

  # Make sure the agent knows my keys; re-adding prompts for a passphrase.
  # Skip keys that are already loaded, matching by fingerprint.
  ssh-add -l >/dev/null 2>&1; or return

  for key in ~/.ssh/id_ed25519 ~/.ssh/id_rsa
    test -f "$key"; or continue
    set -l fp (ssh-keygen -lf "$key" | awk '{print $2}')
    ssh-add -l | grep -qF "$fp"; or ssh-add "$key"
  end
end

ssh-init
