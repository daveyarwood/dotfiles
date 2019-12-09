balias t task

function todo
  clear
  task ready; or true
end

balias td todo

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
