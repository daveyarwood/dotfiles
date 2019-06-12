set -gx ADZERK_USE_DOCKER yes
set -gx DOCKER_USER_MODE no

set -gx ADZERK_REPO_PATH $CODEDIR/adzerk
set -gx ADZERK_CLI_TOOLS_REPO_PATH $CODEDIR/cli-tools
set -gx ADZERK_SCRIPTS_PATH $ADZERK_CLI_TOOLS_REPO_PATH/scripts

set -gx SAY_OPTS "-e tempo 1.25 -l en-au"

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

function zerkurl
  if test -z $ADZERK_API_KEY
    echo "ERROR: ADZERK_API_KEY not set."
    return 1
  end

  curl -H X-Adzerk-ApiKey:$ADZERK_API_KEY \
       -H Content-Type:application/json \
       $argv
end

function zch
  if test (count $argv) -ne 1 >/dev/null
    echo "Usage: zch STORY-NUMBER"
    return 1
  end

  xdg-open https://app.clubhouse.io/adzerk/story/$argv[1]
end

# example usage:
#
#   Get story:
#     zchcurl /v2/stories/12345
#
#   Create story:
#     zchcurl /v2/stories -d '{... JSON here ...}'
function zchcurl
  if test -z $CLUBHOUSE_API_TOKEN
    echo "ERROR: CLUBHOUSE_API_TOKEN not set."
    return 1
  end

  if test -z $CLUBHOUSE_MEMBER_ID
    echo "ERROR: CLUBHOUSE_MEMBER_ID not set."
    return 1
  end

  set -l endpoint $argv[1]
  set -e argv[1] # $argv is now any remaining arguments

  curl -L "https://api.clubhouse.io/api$endpoint?token=$CLUBHOUSE_API_TOKEN" \
       -H Content-Type:application/json \
       # exit non-0 unless response is a 200
       # --fail \
       $argv
end

function zchown
  for story_id in $argv
    echo "Fetching story $story_id..."
    set -l story (zchcurl /v2/stories/$story_id -s 2>&1); or return $status

    echo "Adding $CLUBHOUSE_MEMBER_ID as owner..."
    zchcurl /v2/stories/$story_id \
      -X PUT \
      -d (jo owner_ids=(echo $story \
			| jq -c ".owner_ids
				   | . += [\"$CLUBHOUSE_MEMBER_ID\"]
				   | unique")) \
      # Just output the headers to STDERR so I can see if the update was
      # successful.
      -sD /dev/stderr >/dev/null
      or return $status
  end
end

function zchdisown
  for story_id in $argv
    echo "Fetching story $story_id..."
    set -l story (zchcurl /v2/stories/$story_id -s 2>&1); or return $status

    echo "Removing $CLUBHOUSE_MEMBER_ID as owner/follower..."
    zchcurl /v2/stories/$story_id \
      -X PUT \
      -d (jo owner_ids=(echo $story \
			| jq -c ".owner_ids | . -= [\"$CLUBHOUSE_MEMBER_ID\"]")  \
	     follower_ids=(echo $story \
			   | jq -c ".follower_ids | . -= [\"$CLUBHOUSE_MEMBER_ID\"]")) \
      # Just output the headers to STDERR so I can see if the update was
      # successful.
      -sD /dev/stderr >/dev/null
      or return $status
  end
end
