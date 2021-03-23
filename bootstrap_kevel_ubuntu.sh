#!/usr/bin/env bash

set -eo pipefail

# This part is difficult to automate. It involves clicking a button on the Slack
# website to download a .deb file (the download URL isn't clear from the
# markup), then running a command like (actual filename will vary):
#
#   sudo dpkg -i ~/Downloads/slack-desktop-4.14.0-amd64.deb
echo "*** Install Slack, if you haven't already! ***"
echo

if ! [[ -f "$HOME/.ssh/kevel.pem" ]]; then
  echo "*** Obtain ~/.ssh/kevel.pem and ~/.ssh/config ***"
  echo
fi

echo "*** Install Datadog agent, using the one-liner here: ***"
echo "    https://app.datadoghq.com/account/settings#agent/ubuntu"
echo

# ufw (universal firewall) should be enabled by default, which is great, because
# it's an audit requirement that we all have a firewall enabled.
#
# Just in case, we enable ufw here. If it's already enabled, this is a no-op.
sudo systemctl enable ufw
