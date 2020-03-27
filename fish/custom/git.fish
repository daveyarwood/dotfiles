generate_gitconfig

balias git hub
balias g git
balias gs 'git status'
balias gc 'git commit -v'
balias gco 'git checkout'
function ga; git add $argv; git status; end
balias gl "git log --graph --pretty=format:\"%C(bold blue)%h%C(reset) %C(bold green)%ad%Creset %s%C(bold white) — %an%C(bold yellow)%d%C(reset)\" --decorate --all --date=short"
balias gd 'git diff'
balias gp 'git push'
balias gpf 'git push --force-with-lease'
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

  git submodule update --init --recursive
end

# This is kind of like `git submodule update --remote`, except that it tells me
# what branch(es) contain the commit of each submodule, and updates any
# submodules whose commits are on the master branch, to point to the latest
# commit on the master branch.
function gsu
  for submodule in (ls submodules)
    cd submodules/$submodule
    set commit (git rev-parse HEAD)
    set branches (git branch -r --contains $commit | sed 's/^[* ]\+//')

    set on_master no
    for branch in $branches
      if test $branch = "origin/master"
	set on_master yes
      end
    end

    if test $on_master = yes
      echo "$submodule is on master branch. Updating..."
      git checkout master
      git pull
      # Handle nested submodules
      git submodule update --init --recursive
      cd -
    else
      echo "ERROR: $submodule submodule is on non-master branch: $branches"
      cd -
    end
  end
end
