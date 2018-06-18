balias todo "task ready"
balias td "task ready"

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

function tdone
  task $argv done
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
  task $argv[1] modify scheduled:$argv[2]
  todo
end

balias tsn tsnooze

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
