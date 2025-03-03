#!/bin/bash

# Make local bin directory available
export PATH="$HOME/.local/bin:$PATH"

echo '---'
echo 'Installing asdf'
echo '---'
ASDF_RELEASE_URL="https://github.com/asdf-vm/asdf/releases/download/v0.16.2/asdf-v0.16.2-linux-amd64.tar.gz"
wget "$ASDF_RELEASE_URL" -O ~/.local/bin/asdf.tar.gz
tar -xzf ~/.local/bin/asdf.tar.gz -C ~/.local/bin
rm ~/.local/bin/asdf.tar.gz
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

echo '---'
echo 'Installing nodejs'
echo '---'
NODE_VER="22.14.0"
asdf plugin add nodejs
asdf install nodejs $NODE_VER
asdf set -u nodejs $NODE_VER

echo '---'
echo 'Installing php'
echo '---'
PHP_VER="8.4.4"
sudo apt-get install -y autoconf bison build-essential curl gettext git libgd-dev libcurl4-openssl-dev libedit-dev libicu-dev libjpeg-dev libmysqlclient-dev libonig-dev libpng-dev libpq-dev libreadline-dev libsqlite3-dev libssl-dev libxml2-dev libzip-dev openssl pkg-config re2c zlib1g-dev libsodium-dev
asdf plugin add php
ASDF_CONCURRENCY=4 PHP_CONFIGURE_OPTIONS="--with-openssl --with-curl --with-zlib --with-readline --with-gettext --with-sodium" asdf install php $PHP_VER
asdf set -u php $PHP_VER

echo '---'
echo 'Install lua-language-server'
echo '---'
LUA_LANGUAGE_SERVER_VER="3.13.6"
asdf plugin add lua-language-server
asdf install lua-language-server $LUA_LANGUAGE_SERVER_VER
asdf set -u lua-language-server $LUA_LANGUAGE_SERVER_VER
