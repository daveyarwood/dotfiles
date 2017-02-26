if test (uname) = Darwin
  set -gx RBENV_ROOT /usr/local/var/rbenv
else
  set -gx RBENV_ROOT $HOME/.rbenv
end

if status is-interactive
  # on astrocat, the script that (rbenv init - | psub) emits is in bash instead
  # of fish for some reason. I don't feel like shaving this yak, so just
  # explicitly use bash if hostname is astrocat.
  if test (hostname) = astrocat
    bash (rbenv init - | psub)
  else
    source (rbenv init - | psub)
  end
end

