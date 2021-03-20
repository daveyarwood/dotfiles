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

if test -z "$SSH_ENV"
  setenv SSH_ENV $HOME/.ssh/environment
end

if not __ssh_agent_is_started
  __ssh_agent_start
end

# apparently this has to be run once per session now
ssh-add -A > /dev/null ^&1
# make sure SSH agent knows about my keys (this should work anyway, but tmux
# can throw a wrench in things, so this will make sure it always works)
ssh-add ~/.ssh/*.pem >/dev/null 2>&1
# I can't get this to be non-interactive
# echo (ssh-add ~/.ssh/id_rsa)

# if gnome-keyring-daemon exists, start it and use the result to set
# SSH_AUTH_SOCK
which gnome-keyring-daemon >/dev/null
if test $status -eq 0
  eval (gnome-keyring-daemon --start | sed 's/SSH_AUTH_SOCK=/set SSH_AUTH_SOCK /')
end

