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

# Add `pacs` to PATH, along with whatever other scripts they might add to this
# dir in the future.
add-dirs-to-path $CODEDIR/infrastructure/scripts

function kescalate
  if test (count $argv) -ne 1
    echo "Usage: kescalate sc-XXXXX"
    return 1
  end

  set -l ticket_id $argv[1]

  set -l pacs_output (mktemp)
  pacs -t $ticket_id > $pacs_output

  set -gx AWS_ACCESS_KEY_ID (jq -r '.AWS_ACCESS_KEY_ID' $pacs_output)
  set -gx AWS_SECRET_ACCESS_KEY (jq -r '.AWS_SECRET_ACCESS_KEY' $pacs_output)
  set -gx AWS_SESSION_TOKEN (jq -r '.AWS_SESSION_TOKEN' $pacs_output)
  set -gx KEVEL_ESCALATION_TICKET (jq -r '.escalationTicket' $pacs_output)
  set -gx KEVEL_ACCOUNT_ID (jq -r '.accountId' $pacs_output)
  set -gx KEVEL_ROLE_SES_NAME (jq -r '.role_ses_name' $pacs_output)
  set -gx KEVEL_AWS_CONSOLE_URL (jq -r '.AWS_console_Login' $pacs_output)

  rm $pacs_output

  # Remove other AWS env vars hanging around from the role I needed to have
  # assumed in order to escalate.
  set -e AWS_PROFILE AWS_CREDENTIAL_EXPIRATION

  # Since the escalated credentials don't have a profile where I could specify
  # the region, I'll set it via the env var instead.
  set -gx AWS_DEFAULT_REGION us-east-1
end

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

function shortcut-member-id
  zchcurl /v3/member -s --fail | jq -r '.id'
end

function zchcreate
  if test (count $argv) -lt 1 || test (count $argv) -gt 2
    echo "Usage: zchcreate TITLE [DESCRIPTION]"
    return 1
  end

  set -l title $argv[1]
  set -l description $argv[2]

  if test -z "$description"
    set description "Story created by script. TODO: Write description"
  end

  set -l me (shortcut-member-id || return 1)

  # I'll probably use this script for chore tasks most of the time. If there is
  # an exception, I can just change the story type after the fact.
  set -l story_type "chore"

  set -l group_id "5eb164af-7cbb-450a-9821-9bacd12a6a4e" # Team: Management
  set -l workflow_state_id 500000006 # Engineering & Support - Crushing
  set -l project_id 6 # Management

  set -l story_json \
    (zchcurl \
       "/v3/stories" \
       -s --fail \
       -d (jo "name=$title" \
              "description=$description" \
              "owner_ids="(jo -a "$me") \
              "project_id=$project_id" \
              "group_id=$group_id" \
              "workflow_state_id=$workflow_state_id" \
              "story_type=$story_type"))

  set -l story_id (echo "$story_json" | jq -r '.id')
  set -l story_url (echo "$story_json" | jq -r '.app_url')

  echo "Story ID: $story_id"

  # Open story in browser for editing
  xdg-open "$story_url"
end

function zchown
  set -l shortcut_member_id (shortcut-member-id || return 1)

  for story_id in $argv
    echo "Fetching story $story_id..."
    set -l story (zchcurl /v2/stories/$story_id -s 2>&1); or return $status

    echo "Adding $shortcut_member_id as owner..."
    zchcurl /v2/stories/$story_id \
      -X PUT \
      -d (jo owner_ids=(echo $story \
			| jq -c ".owner_ids
				   | . += [\"$shortcut_member_id\"]
				   | unique")) \
      # Just output the headers to STDERR so I can see if the update was
      # successful.
      -sD /dev/stderr >/dev/null
      or return $status
  end
end

function zchdisown
  set -l shortcut_member_id (shortcut-member-id || return 1)

  for story_id in $argv
    echo "Fetching story $story_id..."
    set -l story (zchcurl /v2/stories/$story_id -s 2>&1)
    if test $status -ne 0
      echo $story
      return $status
    end

    echo "Removing $shortcut_member_id as owner/follower..."
    zchcurl /v2/stories/$story_id \
      -X PUT \
      -d (jo owner_ids=(echo $story \
			| jq -c ".owner_ids | . -= [\"$shortcut_member_id\"]")  \
	     follower_ids=(echo $story \
			   | jq -c ".follower_ids | . -= [\"$shortcut_member_id\"]")) \
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
