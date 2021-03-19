function alda-api-status
  if test (curl -s \
             -o /dev/null \
             -w "%{http_code}" \
             https://api.alda.io/releases/latest) = "200"
    set_color --dim white
    echo "Alda API is up."
    set_color normal
  else
    set_color --bold red
    echo "Alda API is down!"
    set_color normal
  end
end

function fish_greeting;
  if not nmcli dev | grep wifi | grep -q disconnected
    alda-api-status
  end

  if which task >/dev/null
    if which task-projects >/dev/null
      task-projects
    else
      which snooze-tasks >/dev/null; and snooze-tasks
      task ready 2>/dev/null
    end
  end
end

# Erase the default fish_mode_prompt; I have one built into my theme below.
function fish_mode_prompt; end

# Returns the number of subshells deep we are.
#
# For some reason, in my shell, $SHLVL is 2 initially, so this function adjusts
# for that and treats my initial nesting level as 0.
function nesting_level
  math -- "$SHLVL - 2"
end

function taskwarrior_task_count
  which task >/dev/null; or return
  set -l tasks_ready (task ready 2>/dev/null | grep -E '[0-9]+ tasks?')
  test $status -eq 0; or return
  printf ' (%s ready)' $tasks_ready
end

# Cribbed from oh-my-fish.
function prompt_segments -d "extract root, dir and base from fish_prompt"
  set -l root (prompt_pwd | cut -d "/" -f1)
  if test -z "$root"
    echo "/"
  else
    echo "$root"
  end
  set -l path (prompt_pwd | cut -d "/" -f2-)
  set -l dir (dirname $path)
  if test $dir != "."
    echo $dir
  end
  set -l base (basename $path)
  if test -n "$base" -a "$base" != "~"
    echo $base
  end
end

function fish_prompt
  set -l last_command_status $status
  if test $last_command_status -ne 0
    set_color --bold red
    echo "Exit code: $last_command_status"
    set_color normal
  end

  echo

  if test (nesting_level) -gt 0
    printf "%d) " (nesting_level)
  end

  set -l mode_color

  switch $fish_bind_mode
    case default # normal mode
      set mode_color green
    case visual
      set mode_color cyan
    case '*' # insert mode or anything else
      set mode_color yellow
  end

  set_color --bold $mode_color
  echo -n (prompt_segments | tail -n1)

  set_color normal # undoes --bold
  set_color --dim white
  taskwarrior_task_count
  set_color normal # undoes the --dim

  set_color --bold $mode_color
  printf ' → '

  set_color normal
end
