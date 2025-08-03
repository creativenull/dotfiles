#!/usr/bin/env bash

export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$HOME/.local/bin:$PATH"

echo '=> Installing rust'

RUST_VER="latest:1"
rust_install() {
	asdf plugin add rust
	asdf install rust $RUST_VER
	asdf set -u rust $RUST_VER
}

if [ "$(which rustc)" != "" ]; then
	read -p "=> rust: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" = "y" ]; then
		rust_install
	else
		echo "=> Skipping"
	fi
else
	rust_install
fi
