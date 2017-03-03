# bundler seems to work fine on OS X, so I don't want to mess with it.
# In my Linux VM, though, I have to set my GEM_HOME for whatever reason.
if test (hostname) = 'astrocat'
  set -gx GEM_HOME $HOME/.gem
  set -gx PATH $GEM_HOME/bin $PATH
end
