set -l rakudo_dir /opt/rakudo-pkg/bin

if test -d $rakudo_dir
  set -gx PATH $rakudo_dir $PATH
end

