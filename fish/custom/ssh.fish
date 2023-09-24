# source: https://github.com/tuvistavie/fish-ssh-agent

function __ssh_agent_is_started -d "check if ssh agent is already started"
  if begin; test -f $SSH_ENV; and test -z "$SSH_AGENT_PID"; end
    source $SSH_ENV > /dev/null
  end

  if test -z "$SSH_AGENT_PID"
    return 1
  end

  ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep -q ssh-agent
  return $status
end

function __ssh_agent_start -d "start a new ssh agent"
  ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
  chmod 600 $SSH_ENV
  source $SSH_ENV > /dev/null
end

function ssh-init
  if test -z "$SSH_ENV"
    setenv SSH_ENV $HOME/.ssh/environment
  end

  if not __ssh_agent_is_started
    __ssh_agent_start
  end

  # If gnome-keyring-daemon exists and isn't already running, start it and use
  # the result to set SSH_AUTH_SOCK.
  #
  # NOTE: We want to avoid always doing this, because sometimes SSH_AUTH_SOCK
  # appears to already be set to the value we want, and then it gets clobbered
  # to be /run/user/1000/keyring/ssh instead, and `ssh-add -l` output shows that
  # my key isn't available.
  if command -v gnome-keyring-daemon >/dev/null \
    && not ps aux | grep -v grep | grep -q gnome-keyring-daemon
    eval (gnome-keyring-daemon --start | sed 's/SSH_AUTH_SOCK=/set SSH_AUTH_SOCK /')
  end

  # 2022-08-17: I randomly started having problems with this again today.
  # SSH_AUTH_SOCK somehow ended up getting set to the wrong value. In general,
  # I want to trust whatever SSH_AUTH_SOCK gets set to, but I also have to
  # expect that it will be set to the wrong thing sometimes. So here, I am doing
  # a simple check to see if it's set to something invalid, and if it is, then
  # I pick the first file matching the expected pattern and use that instead.
  if ! ssh-add -l >/dev/null 2>/dev/null
    set -gx SSH_AUTH_SOCK (ss -xl | grep -E '/tmp/ssh.*agent' | awk '{print $5}' | head -n1)
  end

  # Make sure SSH agent knows about my keys. This should Just Work, but tmux can
  # throw a wrench in things, so this will make sure it always works. Whenever
  # I re-add a key, it prompts me for the passphrase.
  if ! ssh-add -l | grep id_rsa > /dev/null
    ssh-add ~/.ssh/id_rsa
  end
end

ssh-init
