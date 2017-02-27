set -l pg_dir /Applications/Postgres.app/Contents/Versions/9.3/bin

if test -d $pg_dir
  set -gx PATH $pg_dir $PATH
end

