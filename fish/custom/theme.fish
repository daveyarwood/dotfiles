# Returns the status code (e.g. 200) of the last recorded Alda API status.
#
# If there are no recorded Alda API statuses in the last 5 minutes, returns
# nothing.
function last-alda-api-status
  set -l results_dir /tmp/alda-api-status-results/

  if ! test -d "$results_dir"
    return
  end

  set -l status_file (find \
                        "$results_dir" \
                        -type f \
                        -mmin -5 \
                        | sort | tail -n1)

  # Usually, I would write if [[ -n "$status_file" ]], but for some reason, when
  # there are 0 results, $status_file ends up being a 1-character empty string
  # of some kind. Maybe a quirk of fish?
  if test (echo $status_file | wc -c) -gt 1
    cat $status_file
  end
end

function fish_greeting;
  set -l status_code (last-alda-api-status)

  if test -z $status_code
    # No status recorded in the last 5 minutes, so do nothing. I could go ahead
    # and check the status explicitly here, but I don't want to delay the
    # terminal starting up. I'm sure I'll notice if I don't see anything printed
    # here for a while.
  else if test $status_code = 200
    set_color --dim white
    echo "Alda API is up."
    set_color normal
  else
    set_color --bold red
    echo "Alda API is down!"
    set_color normal
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

  set_color normal # Undoes --bold

  # 2024-08-09 Hacks on top of hacks. nvm fails to use the correct Node version
  # when I enter this directory (see `custom/node.fish`). Ideally, I should fix
  # that, but for now, I at least want visibility in my prompt if I'm
  # unexpectedly using the wrong version of Node.
  if test $PWD = "$HOME/code/spark"
    set_color --italic
    echo -n " (node "(node --version)")"
    set_color normal
  end

  if test -n "$AWS_PROFILE"
    echo -n " "
    set_color --background blue
    echo -n $AWS_PROFILE
  end

  set_color normal # Undoes background color, if any
  set_color --bold $mode_color

  printf ' → '

  set_color normal
end

# 2025-03-25: Fish now appears to set the cursor to "line" in insert mode, but
# for years, I've been used to the cursor always being "block". This ensures
# that the cursor will still be "block" in insert mode.
set fish_cursor_insert block
