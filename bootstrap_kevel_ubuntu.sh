#!/usr/bin/env bash

set -eo pipefail

function press-enter-to-continue() {
  echo
  echo "  -- Press ENTER to continue --"
  read
}

echo "Updating/upgrading existing apt packages..."
echo
sudo apt update
sudo apt upgrade -y
echo

# Reference:
# https://app.tettra.co/teams/adzerk/pages/new-engineer-access-to-tooling#header-7vnpc-a-working-environment
#
# 2021-03-23: At the time of writing, OpenJDK 16 is the newest version
# available. I think it would be better to install the newest available version,
# however, the newest version currently available in the Ubuntu 20.04 default
# PPA is OpenJDK 14. I think this is sufficiently new; the Tettra doc linked
# above says to install JDK 11+.
echo "Installing various apt packages..."
echo
sudo apt install -y \
  curl \
  git-all \
  jq jo \
  openjdk-14-jre \
  libsecret-1-0 libsecret-1-dev \
  redis-tools
echo

echo "Installing Node.js..."
echo
curl -fsSL https://deb.nodesource.com/setup_15.x | sudo -E bash -
sudo apt install -y nodejs
npm config set prefix ~/npm
echo

echo "Installing Clojure CLI..."
echo
pushd /tmp > /dev/null
clj_installer="linux-install-1.10.3.814.sh"
curl -O "https://download.clojure.org/install/$clj_installer"
chmod +x "$clj_installer"
sudo "./$clj_installer"
rm "$clj_installer"
popd > /dev/null
echo

# Source: https://github.com/boot-clj/boot#install
echo "Installing Boot..."
sudo bash -c "cd /usr/local/bin && curl -fsSLo boot https://github.com/boot-clj/boot-bin/releases/download/latest/boot.sh && chmod 755 boot"
echo

# This part is difficult to automate. It involves clicking a button on the Slack
# website to download a .deb file (the download URL isn't clear from the
# markup), then running a command like (actual filename will vary):
#
#   sudo dpkg -i ~/Downloads/slack-desktop-4.14.0-amd64.deb
echo "*** Install Slack, if you haven't already! ***"
press-enter-to-continue

# This part is also difficult to automate, for similar reasons.
echo "*** Install Zoom, if you haven't already! ***"
press-enter-to-continue

if ! [[ -f "$HOME/.ssh/kevel.pem" ]]; then
  echo "*** Obtain ~/.ssh/kevel.pem and ~/.ssh/config ***"
  press-enter-to-continue
fi

echo "*** Install Datadog agent, using the one-liner here: ***"
echo "    https://app.datadoghq.com/account/settings#agent/ubuntu"
press-enter-to-continue

# ufw (universal firewall) should be enabled by default, which is great, because
# it's an audit requirement that we all have a firewall enabled.
#
# Just in case, we enable ufw here. If it's already enabled, this is a no-op.
echo "Enabling firewall..."
echo
sudo systemctl enable ufw
echo

# Automating encrypting your home directory / hard drive if it isn't already
# would be challenging, if not impossible, to do as part of this script. And the
# person running the script may have opinions about how best to do that, anyway.
#
# So, instead, we'll just check to see if it's already encrypted (in a
# rudimentary way), and if it isn't, we'll give the person running the script a
# heads up.
if ! grep -qi private <(mount); then
  echo "*** It looks like your hard drive might not be encrypted. ***"
  echo "    Make sure you do that, as it's an audit requirement!"
  press-enter-to-continue
fi

# Reference:
# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
echo "Installing AWS CLI..."
echo
pushd /tmp > /dev/null
curl \
  "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
  -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
popd > /dev/null
echo

echo "Installing AWS X-Ray daemon..."
echo
pushd /tmp > /dev/null
xray_deb="aws-xray-daemon-3.x.deb"
curl \
  -o "$xray_deb" \
  "https://s3.us-east-2.amazonaws.com/aws-xray-assets.us-east-2/xray-daemon/$xray_deb"
sudo dpkg -i "$xray_deb"
cat <<EOF
*** Out of the box, installing the X-Ray .deb file enabled a systemd service
    that keeps the X-Ray daemon running at all times. However, for this to
    work, the daemon would need to have access to your AWS credentials. Putting
    your credentials in ~/.aws/credentials would work, but then you'd have your
    AWS credentials on your hard drive in plain text.

    A safer route is to set the AWS_ environment variables in a shell (e.g.
    decrypting and sourcing an encrypted Bash script that sets them) and run
    \`xray\` in the foreground.

    Stopping and disabling the X-Ray systemd service now. ***
EOF
sudo systemctl stop xray
sudo systemctl disable xray
popd > /dev/null
echo
