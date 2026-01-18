#!/usr/bin/env bash
set -euo pipefail

install_brew_pkgs=1
install_mise_pkgs=1
setup_mysql_server=1

sudo apt update && sudo apt upgrade -y

pkgs=(
	autoconf
	bat
	bison
	btop
	build-essential
	cmake
	curl
	file
	gettext
	git
	httpie
	libcurl4-openssl-dev
	libedit-dev
	libffi-dev
	libgd-dev
	libgmp-dev
	libicu-dev
	libjpeg-dev
	libmysqlclient-dev
	libonig-dev
	libpng-dev
	libpq-dev
	libreadline-dev
	libsodium-dev
	libsqlite3-dev
	libssl-dev
	libxml2-dev
	libyaml-dev
	libzip-dev
	mysql-client-8.0
	mysql-server-8.0
	ninja-build
	openssl
	patch
	pkg-config
	procps
	python3-pip
	python3-pynvim
	python3-setuptools
	python3-wheel
	re2c
	ripgrep
	software-properties-common
	sqlite3
	unzip
	vim
	zip
	zlib1g-dev
	zsh
)

printf "=> Installing apt packages\n"
sudo apt install -y "${pkgs[@]}"

if [ $install_brew_pkgs -eq 1 ]; then
	printf "=> Installing Homebrew\n"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	brew_pkgs=(
		deno
		efm-langserver
		lsd
		lua-language-server
		mise
		neovim
		starship
		stylua
		zellij
	)

	printf "=> Installing brew packages\n"
	brew install gcc
	brew install "${brew_pkgs[@]}"
fi

if [ $install_mise_pkgs -eq 1 ]; then
	printf "=> Installing mise plugins\n"
	mise settings add disable_backends asdf
	mise use -g nodejs@22
	mise use -g rust@latest
	mise use -g ruby@latest
	mise use -g php@8.4
fi

if [ $setup_mysql_server -eq 1 ]; then
	printf "=> Setup MySQL local dev server\n"
	sudo mysql_secure_installation <<EOF

n # Change the password? No
n # Remove anonymous users? Yes
y # Disallow root login remotely? Yes
y # Remove test database and access to it? Yes
y # Reload privilege tables now? Yes
EOF

	# Login to MySQL and create the user and grant privileges
	sudo mysql <<EOF
CREATE USER 'creativenull'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'creativenull'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

fi
