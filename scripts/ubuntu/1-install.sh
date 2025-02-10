#!/bin/bash

echo 'Installing updates'
sudo apt-get update && sudo apt-get upgrade -y

echo 'Installing packages'
sudo apt-get install -y \
    build-essential \
    autoconf \
    curl \
    wget \
    zsh \
    fzf \
    ripgrep \
    lsd \
    zip \
    unzip \
    python3-pip \
    python3-venv \
    python3-pynvim

echo 'Install mysql-server'
MYSQL_PWD=password
echo "mysql-server mysql-server/root_password password $MYSQL_PWD" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $MYSQL_PWD" | debconf-set-selections
echo "mysql-server mysql-server/start_on_boot boolean true" | debconf-set-selections
sudo apt-get install -y mysql-server

echo 'Installing jetbrains mono nerdfonts'
mkdir -p ~/.fonts
JETBRAINS_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip"
wget "$JETBRAINS_URL" -O ~/.fonts/JetBrainsMono.zip
unzip ~/.fonts/JetBrainsMono.zip -d ~/.fonts
rm ~/.fonts/JetBrainsMono.zip

echo 'Adding ~/.local/bin to $PATH'
mkdir -p ~/.local/bin
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zprofile
export PATH="$HOME/.local/bin:$PATH"

echo 'Installing asdf'
ASDF_RELEASE_URL="https://github.com/asdf-vm/asdf/releases/download/v0.16.2/asdf-v0.16.2-linux-amd64.tar.gz"
wget "$ASDF_RELEASE_URL" -O ~/.local/bin/asdf.tar.gz
tar -xzf ~/.local/bin/asdf.tar.gz -C ~/.local/bin
rm ~/.local/bin/asdf.tar.gz

echo 'Installing kitty'
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
mkdir -p ~/.local/share/applications
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
echo 'kitty.desktop' > ~/.config/xdg-terminals.list

echo 'Installing deno'
DENO_VER="2.1.9"
asdf plugin add deno https://github.com/asdf-community/asdf-deno.git
asdf install deno $DENO_VER
asdf set -u deno $DENO_VER

echo 'Installing nodejs'
NODE_VER="20.18.0"
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs $NODE_VER
asdf set -u nodejs $NODE_VER

echo 'Installing php'
PHP_VER="8.4.3"
asdf plugin add php https://github.com/asdf-community/asdf-php.git
PHP_CONFIGURE_OPTIONS="--with-openssl --with-curl --with-zlib --with-readline --with-gettext --with-sodium" asdf install php $PHP_VER
asdf set -u php $PHP_VER

echo 'Installing starship'
curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin

echo 'Installing efm-langserver'
EFM_URL="https://github.com/mattn/efm-langserver/releases/download/v0.0.54/efm-langserver_v0.0.54_linux_amd64.tar.gz"
wget "$EFM_URL" -O ~/.local/bin/efm-langserver.tar.gz
tar -xzf ~/.local/bin/efm-langserver.tar.gz -C ~/.local/bin
rm ~/.local/bin/efm-langserver.tar.gz

echo 'Installing stylua'
STYLUA_URL="https://github.com/JohnnyMorganz/StyLua/releases/download/v2.0.2/stylua-linux-x86_64.zip"
wget "$STYLUA_URL" -O ~/.local/bin/stylua.zip
unzip ~/.local/bin/stylua.zip -d ~/.local/bin
rm ~/.local/bin/stylua.zip

echo 'Installing neovim'
NVIM_VER="v0.10.4"
git clone --depth 1 --branch $NVIM_VER https://github.com/neovim/neovim.git ~/.builds/neovim
sudo apt-get install -y ninja-build gettext cmake
cd ~/.builds/neovim
make distclean && make -j2 CMAKE_BUILD_TYPE=Release
sudo make install
