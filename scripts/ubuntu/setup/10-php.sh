echo '---'
echo 'Installing php'
echo '---'

php_install() {
	sudo apt install -y autoconf bison build-essential curl gettext git libgd-dev libcurl4-openssl-dev libedit-dev \
		libicu-dev libjpeg-dev libmysqlclient-dev libonig-dev libpng-dev libpq-dev libreadline-dev libsqlite3-dev \
		libssl-dev libxml2-dev libzip-dev openssl pkg-config re2c zlib1g-dev libsodium-dev

	PHP_VER="8.4.4"
	asdf plugin add php
	ASDF_CONCURRENCY=4 PHP_CONFIGURE_OPTIONS="--with-openssl --with-curl --with-zlib --with-readline --with-gettext --with-sodium" asdf install php $PHP_VER
	asdf set -u php $PHP_VER
}

if command -v php &> /dev/null
then
	read -p "php: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" = "y" ]; then
		php_install
	else
		echo "Skipping: php already installed"
	fi
else
	php_install
fi
