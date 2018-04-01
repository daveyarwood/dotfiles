set -l lenvrc $HOME/.lenvrc

if test -f $lenvrc; and type --quiet bass
  bass . $lenvrc
end
