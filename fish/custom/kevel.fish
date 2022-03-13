# Something is still setting this for some reason. Maybe tmux is throwing
# a wrench in things? Let's just un-set it here if it's set. ¯\_(ツ)_/¯
set -e ADZERK_BUILD_CHROOT || true

set -gx ADZERK_USE_DOCKER no
set -gx DOCKER_USER_MODE no

set -gx ADZERK_REPO_PATH $CODEDIR/adzerk
set -gx ADZERK_CLI_TOOLS_REPO_PATH $CODEDIR/cli-tools
set -gx ADZERK_SCRIPTS_PATH $ADZERK_CLI_TOOLS_REPO_PATH/scripts

set -gx SAY_OPTS "-e tempo 1.25 -l en-uk"

alias adzerk $ADZERK_CLI_TOOLS_REPO_PATH/adzerk

function zerkurl
  if test -z $ADZERK_API_KEY
    echo "ERROR: ADZERK_API_KEY not set."
    return 1
  end

  curl -H X-Adzerk-ApiKey:$ADZERK_API_KEY \
       -H Content-Type:application/json \
       $argv
end

# example usage:
#
#   Get story:
#     zchcurl /v2/stories/12345
#
#   Create story:
#     zchcurl /v2/stories -d '{... JSON here ...}'
function zchcurl
  if test -z $SHORTCUT_API_TOKEN
    echo "ERROR: SHORTCUT_API_TOKEN not set."
    return 1
  end

  set -l endpoint $argv[1]
  set -e argv[1] # $argv is now any remaining arguments

  curl -L "https://api.app.shortcut.com/api$endpoint?token=$SHORTCUT_API_TOKEN" \
       -H Content-Type:application/json \
       # exit non-0 unless response is a 200
       # --fail \
       $argv
end

function zchown
  if test -z $SHORTCUT_MEMBER_ID
    echo "ERROR: SHORTCUT_MEMBER_ID not set."
    return 1
  end

  for story_id in $argv
    echo "Fetching story $story_id..."
    set -l story (zchcurl /v2/stories/$story_id -s 2>&1); or return $status

    echo "Adding $SHORTCUT_MEMBER_ID as owner..."
    zchcurl /v2/stories/$story_id \
      -X PUT \
      -d (jo owner_ids=(echo $story \
			| jq -c ".owner_ids
				   | . += [\"$SHORTCUT_MEMBER_ID\"]
				   | unique")) \
      # Just output the headers to STDERR so I can see if the update was
      # successful.
      -sD /dev/stderr >/dev/null
      or return $status
  end
end

function zchdisown
  if test -z $SHORTCUT_MEMBER_ID
    echo "ERROR: SHORTCUT_MEMBER_ID not set."
    return 1
  end

  for story_id in $argv
    echo "Fetching story $story_id..."
    set -l story (zchcurl /v2/stories/$story_id -s 2>&1)
    if test $status -ne 0
      echo $story
      return $status
    end

    echo "Removing $SHORTCUT_MEMBER_ID as owner/follower..."
    zchcurl /v2/stories/$story_id \
      -X PUT \
      -d (jo owner_ids=(echo $story \
			| jq -c ".owner_ids | . -= [\"$SHORTCUT_MEMBER_ID\"]")  \
	     follower_ids=(echo $story \
			   | jq -c ".follower_ids | . -= [\"$SHORTCUT_MEMBER_ID\"]")) \
      # Just output the headers to STDERR so I can see if the update was
      # successful.
      -sD /dev/stderr >/dev/null
      or return $status
  end
end

function zdb
  set -l zone $argv[1]

  eval $CODEDIR/teammgmt/bin/sql-env --zone $zone zclsql $argv[2..-1]
end

alias zecret $CODEDIR/teammgmt/bin/zecret

function save-zecret
  if test (count $argv) -ne 2
    echo "Usage: save-zecret NAME VALUE"
    return 1
  end

  set -l name $argv[1]
  set -l value $argv[2]

  set -l secrets_dir "$HOME/.adzerk/secrets"
  mkdir -p "$secrets_dir"

  set -l unencrypted_secret "$secrets_dir/$name"
  echo "$value" > "$unencrypted_secret"
  # creates $unencrypted_secret.asc
  gpg -ea --default-recipient-self "$unencrypted_secret"
  rm "$unencrypted_secret"
end
