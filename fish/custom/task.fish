balias t task

function todo
  clear
  task ready; or true
end

# mnemonic: todo
function td
  which snooze-tasks >/dev/null; and snooze-tasks
  todo
end

# mnemonic: tasks
balias tt td

# mnemonic: projects
function tp
  which snooze-tasks >/dev/null; and snooze-tasks
  which task-projects >/dev/null; and task-projects
end

# mnemonic: projects and tasks
function tpt
  which snooze-tasks >/dev/null; and snooze-tasks
  which task-projects >/dev/null; and task-projects --include-tasks
end

function tadd
  task add $argv
  todo
end

function tann
  task $argv[1] annotate $argv[2..-1]
  todo
end

function tdel
  task $argv delete
  todo
end

function tdep
  task $argv[1] modify depends:$argv[2]
  todo
end

function tdone
  task $argv done
  todo
end

function tdue
  task $argv[1] modify due:$argv[2]
  todo
end

function tedit
  task $argv edit
  todo
end

function tmod
  task $argv[1] modify $argv[2..-1]
  todo
end

function tsnooze
  task $argv[1] modify wait:$argv[2]
  todo
end

balias tsn tsnooze

function tfree
  task $argv[1] modify +freetime
  todo
end

function tstart
  task $argv start
  todo
end

function tstop
  task $argv stop
  todo
end

function tundo
  task undo
  todo
end

function tsync
  task sync
end
