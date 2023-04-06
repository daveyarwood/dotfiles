#!/usr/bin/env bash

set -eo pipefail

function press-enter-to-continue() {
  echo
  echo "  -- Press ENTER to continue --"
  read -r
}

echo "Updating/upgrading existing apt packages..."
echo
sudo apt update
sudo apt upgrade -y
echo

# Reference:
# https://app.tettra.co/teams/adzerk/pages/new-engineer-access-to-tooling#header-7vnpc-a-working-environment
echo "Installing various apt packages..."
echo
sudo apt install -y \
  build-essential make \
  sed \
  rlwrap \
  curl \
  git-all \
  jq jo \
  openjdk-17-jdk \
  libsecret-1-0 libsecret-1-dev \
  redis-tools \
  postgresql-client \
  openvpn openvpn-systemd-resolved \
  mitmproxy \
  pip \
  wget
echo

echo "Installing various pip packages..."
echo
pip install awslogs
echo

# Reference: https://github.com/micha/json-table#install
echo "Installing jt..."
echo
sudo bash -c "cd /usr/local && wget -O - https://github.com/micha/json-table/raw/master/jt.tar.gz | tar xzvf -"

echo "Installing Node.js..."
echo
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install -y nodejs
npm config set prefix ~/npm
echo

echo "Installing Clojure CLI..."
echo
pushd /tmp > /dev/null
clj_installer="linux-install-1.11.1.1155.sh"
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

echo "Smoke test: clone the libclj repo and build standard tooling"
echo "*** Please let Dave know if any of this fails! ***"
echo
git clone https://github.com/adzerk/libclj /tmp/libclj
pushd /tmp/libclj > /dev/null
make tooling
make javac
# `make srepl` starts a REPL, but this script need to be interactive. Echo-ing a
# newline into the process as input causes the process to exit for some reason;
# I don't understand why, but it works for our purposes, so ¯\_(ツ)_/¯
echo | make srepl
popd > /dev/null
echo

# Reference: https://www.mono-project.com/download/stable/
echo "Installing Mono..."
echo
sudo apt install -y gnupg ca-certificates
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt update
sudo apt install -y mono-devel mono-xsp4 nuget
echo

echo "Installing JumpCloud... (required for SOC compliance)"
curl \
  --tlsv1.2 \
  --silent \
  --show-error \
  --header 'x-connect-key: 8546ec80a5f3ca310870dcca7b2de7b7f71e0d66' \
  https://kickstart.jumpcloud.com/Kickstart \
  | sudo bash
echo
echo "*** Notify Jonathan Carpenter so that your user can be bound to your"
echo "    Linux machine.***"
press-enter-to-continue

# Reference:
# https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-connect-linux.html
echo "Installing AWS VPN client..."
echo
wget -q -O - \
  https://d20adtppz83p9s.cloudfront.net/GTK/latest/debian-repo/awsvpnclient_public_key.asc \
  | sudo apt-key add -
echo "deb [arch=amd64] https://d20adtppz83p9s.cloudfront.net/GTK/latest/debian-repo ubuntu-20.04 main" \
  | sudo tee /etc/apt/sources.list.d/aws-vpn-client.list
  sudo apt update
  sudo apt install -y awsvpnclient
echo

echo "*** Get set up to use the AWS VPN ***"
echo
echo "Follow the instructions here:"
echo "https://app.tettra.co/teams/adzerk/pages/kevel-aws-vpn-users-guide"
echo
echo "We just installed the AWS VPN client."
echo
echo "Now you need to download the VPN configuration and make sure you can"
echo "connect to the VPN."
press-enter-to-continue
