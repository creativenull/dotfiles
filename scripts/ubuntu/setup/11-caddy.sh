#!/usr/bin/env bash

echo '=> Installing caddy'

caddy_install() {
	sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
	curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
	curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
	sudo apt update && sudo apt install caddy
}

if command -v caddy &> /dev/null
then
	read -p "=> caddy: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" = "y" ]; then
		caddy_install
	else
		echo "=> Skipping"
	fi
else
	caddy_install
fi
