# Add GHC 7.8.4 to the PATH, via http://ghcformacosx.github.io/
set -gx GHC_DOT_APP /Applications/ghc-7.8.4.app
if test -d $GHC_DOT_APP
    set -gx PATH $HOME/.cabal/bin $GHC_DOT_APP/Contents/bin $PATH
end

