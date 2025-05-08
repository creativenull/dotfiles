#!/usr/bin/env bash

export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$HOME/.local/bin:$PATH"

echo '=> Installing nodejs'

NODE_VER="22.15.0"
nodejs_install() {
	asdf plugin add nodejs
	asdf install nodejs $NODE_VER
	asdf set -u nodejs $NODE_VER
}

if [ "$(which node)" != "" ]; then
	read -p "=> node: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" = "y" ]; then
		nodejs_install
	else
		echo "=> Skipping"
	fi
else
	nodejs_install
fi
