balias zerkenv "bass . $CODEDIR/zerkenv/zerkenv.sh"
balias zd "zerkenv -d"
balias zl "zerkenv -l"
balias zm 'eval \'echo $ZERKENV_MODULES\''
balias zs "zerkenv -s"
balias zsy "zerkenv -y -s"
balias zu "zerkenv -u"
balias zys "zerkenv -y -s"

set -gx DOCKER_USER_MODE no
set -gx ZERKENV_BUCKET zerkenv

set -gx ADZERK_REPO_PATH $CODEDIR/adzerk
set -gx ADZERK_CLI_TOOLS_REPO_PATH $CODEDIR/cli-tools
set -gx ADZERK_SCRIPTS_PATH $ADZERK_CLI_TOOLS_REPO_PATH/scripts

balias adzerk $ADZERK_CLI_TOOLS_REPO_PATH/adzerk

function adzerk-ops-mode
  set -l cli_tools_script_paths alan jarrod jason micha scripts

  for folder in $cli_tools_script_paths
    set -gx PATH $ADZERK_CLI_TOOLS_REPO_PATH/$folder $PATH
  end
end

function adzerk-vpn
  set openvpn_dir /usr/local/etc/openvpn

  if test (hostname) = moondog
    set openvpn_dir /etc/openvpn
  end

	sudo openvpn --config $openvpn_dir/dave.conf $argv;
end

# Start a new mono-docker container.
balias monovm $ADZERK_REPO_PATH/docker/run.sh

# Run a command (or start a shell) in a running mono-docker container.
balias in-monovm $ADZERK_REPO_PATH/docker/attach.sh

