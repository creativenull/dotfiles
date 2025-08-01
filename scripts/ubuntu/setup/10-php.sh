#!/usr/bin/env bash

export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$HOME/.local/bin:$PATH"

echo '=> Installing php'

php_install() {
	sudo nala install -y autoconf bison build-essential curl gettext git libgd-dev libcurl4-openssl-dev libedit-dev \
		libicu-dev libjpeg-dev libmysqlclient-dev libonig-dev libpng-dev libpq-dev libreadline-dev libsqlite3-dev \
		libssl-dev libxml2-dev libzip-dev openssl pkg-config re2c zlib1g-dev libsodium-dev

	PHP_VER="latest:8.4"
	asdf plugin add php
	ASDF_CONCURRENCY=4 PHP_CONFIGURE_OPTIONS="--with-openssl --with-curl --with-zlib --with-readline --with-gettext --with-sodium --with-redis" asdf install php $PHP_VER
	asdf set -u php $PHP_VER
}

if [ "$(which php)" != "" ]; then
	read -p "=> php: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" = "y" ]; then
		php_install
	else
		echo "=> Skipping"
	fi
else
	php_install
fi
