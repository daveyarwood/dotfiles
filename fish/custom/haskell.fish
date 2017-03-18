set -l cabal_path /opt/cabal
set -l dot_cabal_path $HOME/.cabal
set -l ghc_path /opt/ghc

if test -d $ghc_path
  set -gx PATH $ghc_path/bin $PATH
end

if test -d $cabal_path
  set -gx PATH $cabal_path/bin $PATH
end

if test -d $dot_cabal_path
  set -gx PATH $dot_cabal_path/bin $PATH
end

