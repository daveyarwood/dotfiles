set -l dart_dir /usr/lib/dart/bin

if test -d $dart_dir
  set -gx PATH $dart_dir $PATH
end

