set -l heroku_dir /usr/local/heroku/bin

if test -d $heroku_dir
  set -gx PATH $heroku_dir $PATH
end

