# TODO: remove
function adzerk-env
  if count $argv > /dev/null
    if [ $argv[1] = prod ]
      set -gx ADZERK_ENV prod
    else
      set -gx ADZERK_ENV qa
    end
  else
    set -gx ADZERK_ENV qa
  end

  gpg-source $HOME/.adzerk.fish.asc
end

function zerkenv
  bass . $CODEDIR/zerkenv/zerkenv.sh $argv
end

set -gx ZERKENV_BUCKET zerkenv

