# Ensure that these environment variables aren't still set somehow on shell
# startup.
#
# ...unless AWS_PROFILE is set, in which case I don't want to clear them out.
# This is to support my work setup where I have a script that I run that sets
# AWS creds and opens a subshell.
if test -z "$AWS_PROFILE"
  set -e AWS_ACCESS_KEY_ID
  set -e AWS_SECRET_ACCESS_KEY
  set -e AWS_DEFAULT_REGION
end
