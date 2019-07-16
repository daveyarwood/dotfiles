generate_gitconfig

balias git hub
balias g git
balias gs 'git status'
balias gc 'git commit -v'
balias gco 'git checkout'
function ga; git add $argv; git status; end
balias gl "git log --graph --pretty=format:\"%C(yellow)%h %ad%Cred%d %Creset%s%Cblue [%cn]\" --decorate --all --date=short"
balias gd 'git diff'
balias gp 'git push'
balias gpf 'git push --force-with-lease'
balias gpr 'git pull-request'
balias gpt 'git push --tags'
balias gpuo 'git push -u origin'
balias gpud 'git push -u daveyarwood'
balias gb 'git branch'

function gaa
	git add --all $argv; git status;
end

function gpl
  if count $argv >/dev/null
    echo "`gpl` is not a `git pull` alias! It uses `git fetch` and `git merge`. Unable to insert `git pull` arguments, assuming that's what you're trying to do."
    return 1
  end

  git fetch --all --prune
  if test $status -eq 0
    git merge
  end

  git submodule init 2>/dev/null
  if test $status -eq 0
    git submodule update
  end
end
