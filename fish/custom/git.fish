generate_gitconfig

balias git hub
balias g git
balias gs 'git status'
balias gc 'git commit'
balias gco 'git checkout'
function ga; git add $argv; git status; end
balias gl "git log --graph --pretty=format:\"%C(yellow)%h %ad%Cred%d %Creset%s%Cblue [%cn]\" --decorate --all --date=short"
balias gd 'git diff'
balias gp 'git push'
balias gpf 'git push --force-with-lease'
balias gpp 'git pull --prune'
balias gpr 'git pull-request'
balias gpt 'git push --tags'
balias gpuo 'git push -u origin'
balias gpud 'git push -u daveyarwood'

function gaa
	git add --all $argv; git status;
end
