alias t task

function todo
  set -gx TASKWARRIOR_REFRESH_COMMAND td
  clear
  task ready; or true
end

# mnemonic: todo
function td
  which snooze-tasks >/dev/null; and snooze-tasks
  todo
end

# mnemonic: projects
function tp
  set -gx TASKWARRIOR_REFRESH_COMMAND tp
  clear
  which snooze-tasks >/dev/null; and snooze-tasks
  which task-projects >/dev/null; and task-projects
end

# mnemonic: tasks (by project)
function tt
  set -gx TASKWARRIOR_REFRESH_COMMAND tt
  clear
  which snooze-tasks >/dev/null; and snooze-tasks
  which task-projects >/dev/null; and task-projects --include-tasks
end

function task_refresh
  eval $TASKWARRIOR_REFRESH_COMMAND
end

function tadd
  task add $argv
  task_refresh
end

function tann
  task $argv[1] annotate $argv[2..-1]
  task_refresh
end

function tdel
  task $argv delete
  task_refresh
end

function tdep
  task $argv[1] modify depends:$argv[2]
  task_refresh
end

function tdone
  task $argv done
  task_refresh
end

function tdue
  task $argv[1] modify due:$argv[2]
  task_refresh
end

function tedit
  task $argv edit
  task_refresh
end

function tmod
  task $argv[1] modify $argv[2..-1]
  task_refresh
end

function tsnooze
  task $argv[1] modify wait:$argv[2]
  task_refresh
end

alias tsn tsnooze

function tfree
  task $argv[1] modify +freetime
  task_refresh
end

function tstart
  task $argv start
  task_refresh
end

function tstop
  task $argv stop
  task_refresh
end

function tundo
  task undo
  task_refresh
end

function tsync
  task sync
end
