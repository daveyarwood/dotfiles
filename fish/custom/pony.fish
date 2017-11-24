set -l pony_dir $CODEDIR/ponyc/build/release

if test -d $pony_dir
  set -gx PATH $pony_dir $PATH
end

