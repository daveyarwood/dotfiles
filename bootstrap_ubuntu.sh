#!/usr/bin/env bash

set -eo pipefail

################################################################################
# Install misc. apt packages
################################################################################

echo "Updating/upgrading existing apt packages..."
echo
sudo apt update
sudo apt upgrade -y

echo
echo "Installing various apt packages..."
echo
sudo apt install -y \
  software-properties-common \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  wget \
  rlwrap \
  gdebi-core \
  git-all \
  arandr \
  pavucontrol \
  nemo \
  scrot \
  xdotool \
  xsel xclip \
  xcb libxcb-keysyms1-dev libxcb-util0-dev \
  imagemagick \
  compton \
  entr \
  jq \
  htop \
  universal-ctags \
  python3-dev python3-pip \
  rbenv ruby-dev \
  openjdk-17-jdk \
  ack-grep silversearcher-ag ripgrep \
  tmux \
  shellcheck \
  i3 light rofi feh \
  libsecret-1-0 libsecret-1-dev \
  libclang-dev \
  libmagic-dev \
  libgtk-3-dev \
  tlp tlp-rdw acpi-call-dkms \
  audacity \
  inkscape \
  vlc \
  sox libsox-fmt-mp3 \
  timidity \
  syncthing \
  fzf \
  fish \
  gimp \
  newsboat

################################################################################
# Set up /tmp behavior the way I want it
################################################################################

tmpfiles_config="/etc/tmpfiles.d/tmp.conf"

if [[ -f "$tmpfiles_config" ]]; then
  echo
  echo "*** $tmpfiles_config already exists. Hopefully this is OK? ***"
  echo
  cat "$tmpfiles_config"
else
  echo
  echo "Setting up /tmp behavior the way I want it..."
  echo

  sudo tee "$tmpfiles_config" >/dev/null <<EOF
# See: man tmpfiles.d

# Delete everything in /tmp older than 7 days.
d /tmp/ - - - 7d
EOF
fi

################################################################################
# Install Google Chrome
################################################################################

echo
echo "Installing Google Chrome..."
echo

curl \
  -Lo /tmp/google-chrome.deb \
  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

sudo dpkg -i /tmp/google-chrome.deb

################################################################################
# Install Firefox
################################################################################

echo
echo "Installing Firefox..."
echo

# NOTE: The `firefox` package in the default apt repository now points to the
# snap package (╯°□°)╯︵ ┻━┻   So we have to do this instead.
#
# Ref:
# https://www.linuxcapable.com/how-to-remove-firefox-snap-from-ubuntu-linux/
#
# I also had to do this when `sudo snap remove --purge firefox` failed:
# https://askubuntu.com/a/1434769/725987

sudo add-apt-repository ppa:mozillateam/ppa -y

# This ensures that the `firefox` package will refer to the official Firefox
# stable PPA, not the Ubuntu Snapcraft repository.
echo -e "Package: firefox*\nPin: release o=LP-PPA-mozillateam-ppa\nPin-Priority: 550\n\nPackage: firefox*\nPin: release o=Ubuntu\nPin-Priority: -1" \
  | sudo tee /etc/apt/preferences.d/99-mozillateamppa

# Refresh package list.
sudo apt update

# Install Firefox from a REAL apt package.
sudo apt install firefox -y

# Google Chrome greedily sets itself as the default browser without asking.
# (Worse: it asks if I want to set it as the default browser, but it ignores my
# answer and does it anyway.) So, I have to explicitly set it back to something
# else (e.g. firefox) here if we don't want Google Chrome as the default
# browser.
sudo update-alternatives --config x-www-browser

################################################################################
# Install libsecret
################################################################################

# Reference: https://www.softwaredeveloper.blog/git-credential-storage-libsecret

pushd /usr/share/doc/git/contrib/credential/libsecret > /dev/null
sudo make
popd > /dev/null

################################################################################
# Install sxhkd
################################################################################

# Reference: https://github.com/baskerville/sxhkd/pull/135/files
#
# (Maybe someday the maintainer will merge my PR...)

git clone https://github.com/baskerville/sxhkd.git /tmp/sxhkd

pushd /tmp/sxhkd > /dev/null
make
sudo make install
popd > /dev/null

# NOTE: My i3 config starts sxhkd when i3 (re)starts.

################################################################################
# Install fish shell
################################################################################

echo
echo "Making fish the default shell..."
echo

chsh -s "$(command -v fish)"

################################################################################
# Install jenv
################################################################################

echo
echo "Installing jenv..."
echo
git clone https://github.com/jenv/jenv.git ~/.jenv

################################################################################
# Install Node.js
################################################################################

echo
echo "Installing Node.js and various npm packages..."
echo

sudo mkdir -p /etc/apt/keyrings

curl -fsSL \
  https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
  | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

# Current LTS as of 2023-09-24; update as needed
node_major=18

echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$node_major.x nodistro main" \
  | sudo tee /etc/apt/sources.list.d/nodesource.list

sudo apt update
sudo apt install -y nodejs

npm config set prefix ~/npm

# Install various Node and Yarn packages that I need globally.
npm install -g \
  chromedriver vmd yarn diagnostic-languageserver bash-language-server \
  vscode-langservers-extracted eslint_d neovim @bitwarden/cli

################################################################################
# Install Go
################################################################################

echo
echo "Installing Go..."
echo

# Reference: https://golang.org/doc/install

go_version="1.19.13"
go_tarball="go$go_version.linux-amd64.tar.gz"
download_url="https://golang.org/dl/$go_tarball"

pushd /tmp > /dev/null
curl -Lo "$go_tarball" "$download_url"
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "$go_tarball"
rm "$go_tarball"
popd > /dev/null

# This is needed in order for the `go install` commands below to work.
export PATH=$PATH:/usr/local/go/bin

# I have Vim set up to run `goimports` (which is kind of like `gofmt`) every
# time I save a Go file. `goimports` needs to be available on the PATH.
go install golang.org/x/tools/cmd/goimports@latest

# Install gopls (language server)
# Reference: https://github.com/golang/tools/blob/master/gopls/README.md#installation
go install golang.org/x/tools/gopls@latest

# Install staticcheck, which is part of my gopls config and provides some nice
# additional linting
# Reference: https://staticcheck.dev/docs/getting-started/
go install honnef.co/go/tools/cmd/staticcheck@latest

################################################################################
# Install Rust
################################################################################

echo
echo "Installing Rust..."
echo

install_rust="/tmp/install-rust.sh"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > "$install_rust"
chmod +x "$install_rust"
"$install_rust" -y
rm "$install_rust"

################################################################################
# Ruby-related setup
################################################################################

echo
echo "Setting up rbenv..."
echo

mkdir -p ~/.rbenv/plugins
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install various Ruby gems required by scripts I use in my shell config, etc.
gem install --user colorize dotiw bundler watir solargraph neovim

################################################################################
# Install Clojure CLI
################################################################################

echo
echo "Installing Clojure CLI..."
echo

# Ref: https://clojure.org/guides/install_clojure#_linux_instructions

install_clj="/tmp/install-clj.sh"
curl -L \
  https://github.com/clojure/brew-install/releases/latest/download/linux-install.sh \
  > "$install_clj"
chmod +x "$install_clj"
sudo "$install_clj"
rm "$install_clj"

################################################################################
# Install Babashka
################################################################################

echo
echo "Installing Babashka..."
echo

curl -sLo /tmp/install-bb \
  https://raw.githubusercontent.com/babashka/babashka/master/install

chmod +x /tmp/install-bb
/tmp/install-bb --dir "$HOME/bin"
rm /tmp/install-bb

################################################################################
# Install Lua language server
################################################################################

echo
echo "Installing Lua language server..."
echo

(
  version="3.7.3"

  repo="LuaLS/lua-language-server"
  folder="lua-language-server-$version-linux-x64"
  tarball="$folder.tar.gz"

  local_repo="$HOME/bin/$folder"
  mkdir -p "$local_repo"

  curl -L \
    "https://github.com/$repo/releases/download/$version/$tarball" \
    | tar xzvf - -C "$local_repo"

  wrapper_script="$HOME/bin/lua-language-server"

  cat > "$wrapper_script" <<-EOF
#!/usr/bin/env bash

"\$(dirname "\$0")/$folder/bin/lua-language-server" "\$@"
EOF

  chmod +x "$wrapper_script"
)

################################################################################
# Install Kotlin language server
################################################################################

echo
echo "Installing Kotlin language server..."
echo

(
  version="1.3.9"

  repo="fwcd/kotlin-language-server"
  folder="kotlin-language-server-$version"
  zip_file="server.zip"

  staging_dir="/tmp/kotlin-language-server"
  mkdir -p "$staging_dir"

  local_folder="$HOME/bin/$folder"
  mkdir -p "$local_folder"

  curl -L \
    "https://github.com/$repo/releases/download/$version/$zip_file" \
    > "$staging_dir/$zip_file"

  unzip "$staging_dir/$zip_file" -d "$staging_dir"

  mv "$staging_dir/server"/* "$local_folder"

  wrapper_script="$HOME/bin/kotlin-language-server"

  cat > "$wrapper_script" <<-EOF
#!/usr/bin/env bash

"\$(dirname "\$0")/$folder/bin/kotlin-language-server" "\$@"
EOF

  chmod +x "$wrapper_script"
)

################################################################################
# Install Neovim
################################################################################

echo
echo "Installing Neovim..."
echo

sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install -y neovim
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --config vi
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --config vim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
sudo update-alternatives --config editor

python3 -m pip install --user --upgrade pynvim

################################################################################
# Install dotfiles
################################################################################

echo
echo "Installing dotfiles..."
echo

git clone https://github.com/daveyarwood/dotfiles.git "$HOME/.dotfiles"
pushd "$HOME/.dotfiles" > /dev/null
./install
popd > /dev/null

################################################################################
# Install vim-plug
################################################################################

echo
echo "Installing vim-plug..."
echo

sh -c 'curl \
         -fLo \
         "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" \
         --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

nvim +PlugInstall +qall

################################################################################
# Install i3
################################################################################

echo
echo "Setting i3 as the default window manager..."
echo

sudo update-alternatives --install /usr/bin/x-session-manager x-session-manager /usr/bin/i3 60
sudo update-alternatives --config x-session-manager

# Necessary in order for the `light` program (which manages brightness; I have
# key bindings set up so that my brightness up/down keys invoke `light`) to be
# run without sudo.
sudo usermod -a -G video "$USER"
echo "NOTE: You'll need to restart in order for brightness keys to work."

# Set it up so that when I close my laptop lid, it locks i3.
#
# Locking i3 is done via `i3lock`, which is called with specific arguments by
# way of my script ~/.bin/lock-screen, which should exist at this point because
# I installed my dotfiles above.
sudo tee "/etc/systemd/system/suspend@.service" >/dev/null <<EOF
[Unit]
Description=User suspend actions
Before=sleep.target

[Service]
User=%I
Type=forking
Environment=DISPLAY=:0
ExecStart=/home/$USER/.bin/lock-screen
ExecStartPost=/usr/bin/sleep 1

[Install]
WantedBy=sleep.target
EOF

sudo systemctl enable "suspend@$USER.service"

################################################################################
# Install i3-volume (volume control w/ on-screen display notifications)
################################################################################

echo
echo "Installing i3-volume..."
echo

git clone https://github.com/hastinbe/i3-volume.git ~/i3-volume

################################################################################
# Install fonts
################################################################################

echo
echo "Installing fonts..."
echo

mkdir -p ~/.fonts

pushd /tmp > /dev/null

# Nerd Fonts: Hack
# https://www.nerdfonts.com/font-downloads
mkdir -p /tmp/hack-nerd-font
pushd /tmp/hack-nerd-font > /dev/null
curl \
  -Lo font.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
unzip font.zip
rm font.zip
mv ./* ~/.fonts/
popd > /dev/null

################################################################################
# Install kitty
################################################################################

# There is a `kitty` package in the official Ubuntu PPAs, but it's ludicrously
# out-of-date. I am instead following the instructions here:
# https://sw.kovidgoyal.net/kitty/binary

curl -L https://sw.kovidgoyal.net/kitty/installer.sh \
  | sh /dev/stdin

ln -sf \
  ~/.local/kitty.app/bin/kitty \
  ~/.local/kitty.app/bin/kitten \
  ~/.local/bin/

# This makes Kitty available as an option when we run `update-alternatives`
# below to choose a default terminal.
sudo update-alternatives --install \
  /usr/bin/x-terminal-emulator \
  x-terminal-emulator \
  ~/.local/bin/kitty 50

################################################################################
# Install kitty color themes
################################################################################

git clone \
  --depth 1 \
  https://github.com/dexpota/kitty-themes.git \
  ~/.config/kitty/kitty-themes

pushd ~/.config/kitty > /dev/null
ln -s ./kitty-themes/themes/Highway.conf ~/.config/kitty/theme.conf
# Customize the theme to my liking:
# * Brighten color2 from #128033 => #12d033
# * Make color6 (formerly #68838b) an actual cyan => #00eeee
# * Change selection fg/bg colors so that selections are actually readable:
# ** selection_foreground #212224 (fine as is)
# ** selection_background #384563 => #ffffed
sed -i \
  -e 's/\(color2 \+\).\+/\1#12d033/g' \
  -e 's/\(color6 \+\).\+/\1#00eeee/g' \
  -e 's/\(selection_background \+\).\+/\1#ffffed/g' \
  ~/.config/kitty/theme.conf
popd > /dev/null

################################################################################
# Set kitty as default terminal
################################################################################

echo
echo "Choose default terminal (e.g. kitty):"
echo
sudo update-alternatives --config x-terminal-emulator

################################################################################
# Install GitHub CLI
################################################################################

echo
echo "Installing GitHub CLI (gh)..."
echo

# Ref: https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian-ubuntu-linux-raspberry-pi-os-apt

curl \
  -fsSL \
  https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg

sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
  | sudo tee /etc/apt/sources.list.d/github-cli.list \
  > /dev/null

sudo apt update
sudo apt install -y gh

################################################################################
# Install delta (fancy git diff viewer)
################################################################################

echo
echo "Installing delta (fancy git diff viewer)..."
echo

mkdir -p ~/bin

vn="0.6.0"
version="delta-0.6.0-x86_64-unknown-linux-gnu"

curl -L \
  "https://github.com/dandavison/delta/releases/download/$vn/$version.tar.gz" \
  | tar xzvf - -C /tmp

chmod +x "/tmp/$version/delta"

mv "/tmp/$version/delta" ~/bin/

################################################################################
# Install Signal
################################################################################

echo
echo "Installing Signal..."
echo

(
  cd /tmp

  keyring="/usr/share/keyrings/signal-desktop-keyring.gpg"
  repo_url="https://updates.signal.org/desktop/apt"

  wget -O- https://updates.signal.org/desktop/apt/keys.asc \
    | gpg --dearmor \
    | sudo tee -a "$keyring" \
    > /dev/null

  echo "deb [arch=amd64 signed-by=$keyring] $repo_url xenial main" \
    | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list

  sudo apt update && sudo apt install -y signal-desktop
)

################################################################################
# Install Discord
################################################################################

echo
echo "Installing Discord..."
echo

(
  cd /tmp

  wget \
    -O discord.deb \
    "https://discordapp.com/api/download?platform=linux&format=deb"

  sudo gdebi -n discord.deb
)

################################################################################
# Install peek (animated GIF screen recorder)
################################################################################

echo
echo "Installing peek (animated GIF screen recorder)..."
echo

sudo add-apt-repository ppa:peek-developers/stable
sudo apt update
sudo apt install -y peek

################################################################################
# Install Glimpse (image editor)
################################################################################

echo
echo "Installing Glimpse (image editor)..."
echo

sudo snap install glimpse-editor

################################################################################
# Install Spotify
################################################################################

echo
echo "Installing Spotify..."
echo

# Reference: https://www.spotify.com/de-en/download/linux/

curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg \
  | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg

echo "deb http://repository.spotify.com stable non-free" \
  | sudo tee /etc/apt/sources.list.d/spotify.list

sudo apt update
sudo apt install -y spotify-client

################################################################################
# Install Keybase
################################################################################

echo
echo "Installing Keybase..."
echo

# Reference: https://keybase.io/docs/the_app/install_linux

curl \
  https://prerelease.keybase.io/keybase_amd64.deb \
  -o /tmp/keybase.deb

sudo apt install -y /tmp/keybase.deb

run_keybase

rm /tmp/keybase.deb

################################################################################
# Install google_speech
################################################################################

echo
echo "Installing google_speech..."
echo

# Reference: https://github.com/desbma/GoogleSpeech#installation

pip3 install google_speech

################################################################################
# Install Ookla Speedtest CLI
################################################################################

echo
echo "Installing speedtest CLI..."
echo

# Reference: https://www.speedtest.net/apps/cli

sudo apt-get install gnupg1 dirmngr
export INSTALL_KEY=379CE192D401AB61
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $INSTALL_KEY
echo "deb https://ookla.bintray.com/debian generic main" | sudo tee  /etc/apt/sources.list.d/speedtest.list
sudo apt-get update
# Other non-official binaries will conflict with Speedtest CLI
# Example how to remove using apt-get
# sudo apt-get remove speedtest-cli
sudo apt-get install speedtest

################################################################################
# Install jo
################################################################################

# NOTE: You can install `jo` via apt, but the apt package is many versions
# behind the latest release version.

echo
echo "Installing jo..."
echo

(
  jo_version="1.9"
  jo_folder="jo-$jo_version"
  jo_tarball="$jo_folder.tar.gz"

  curl -L \
    "https://github.com/jpmens/jo/releases/download/$jo_version/$jo_tarball" \
    | tar xzvf - -C /tmp

  cd "/tmp/$jo_folder"

  # Reference: https://github.com/jpmens/jo#build-from-release-tarball
  autoreconf -i
  ./configure
  make check
  sudo make install
)

################################################################################
# Install AWS CLI
################################################################################

echo
echo "Installing AWS CLI..."
echo

# Reference:
# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
pushd /tmp > /dev/null
curl \
  "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
  -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
popd > /dev/null
echo

################################################################################
# Install AWS CLI Session Manager (SSM) plugin
################################################################################

echo
echo "Installing AWS CLI Session Manager (SSM) plugin..."
echo

(
  curl \
    "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" \
    -o "/tmp/session-manager-plugin.deb"

  sudo dpkg -i "/tmp/session-manager-plugin.deb"
)


################################################################################
# Install AWS VPN client
################################################################################

echo
echo "Installing AWS VPN client..."
echo

# Reference:
# https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-connect-linux.html
wget -q -O - \
  https://d20adtppz83p9s.cloudfront.net/GTK/latest/debian-repo/awsvpnclient_public_key.asc \
  | sudo apt-key add -
echo "deb [arch=amd64] https://d20adtppz83p9s.cloudfront.net/GTK/latest/debian-repo ubuntu-20.04 main" \
  | sudo tee /etc/apt/sources.list.d/aws-vpn-client.list
  sudo apt update
  sudo apt install -y awsvpnclient
echo

################################################################################
# Install misc. PIP packages
################################################################################

echo
echo "Installing misc. PIP packages..."
echo

pip3 install google_speech

################################################################################

echo
echo "Done!"
