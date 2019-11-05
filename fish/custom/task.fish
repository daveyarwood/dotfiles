function todo
  clear
  task ready; or true
end

balias td todo

function tadd
  clear
  task add $argv
  todo
end

function tann
  clear
  task $argv[1] annotate $argv[2..-1]
  todo
end

function tdel
  clear
  task $argv delete
  todo
end

function tdep
  clear
  task $argv[1] modify depends:$argv[2]
  todo
end

function tdone
  clear
  task $argv done
  todo
end

function tdue
  clear
  task $argv[1] modify due:$argv[2]
  todo
end

function tedit
  clear
  task $argv edit
  todo
end

function tmod
  clear
  task $argv[1] modify $argv[2..-1]
  todo
end

function tsnooze
  clear
  task $argv[1] modify wait:$argv[2]
  todo
end

balias tsn tsnooze

function tstart
  clear
  task $argv start
  todo
end

function tstop
  clear
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
