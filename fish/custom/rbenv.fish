if test (uname) = Darwin
  set -gx RBENV_ROOT /usr/local/var/rbenv
else
  set -gx RBENV_ROOT $HOME/.rbenv
end

# In my Ubuntu environments, the script that (rbenv init - | psub) emits is in
# bash instead of fish for some reason. I don't feel like shaving this yak, so
# just explicitly use bash on the machines in question.
if test (hostname) = astrocat -o (hostname) = moondog
  bash (rbenv init - | psub)
else
  source (rbenv init - | psub)
end

