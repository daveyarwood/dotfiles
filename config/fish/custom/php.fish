set -l php5_dir /usr/local/php5/bin

if test -d $php5_dir
  set -gx PATH $php5_dir $PATH
end

