#!/usr/bin/env bash

echo '=> Installing deno'

deno_install() {
	curl -fsSL https://deno.land/install.sh | sh -s -- --yes --no-modify-path
}

if [ -f ~/.deno/bin/deno ]; then
	read -p "=> deno: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" = "y" ]; then
		deno_install
	else
		echo "=> Skipping"
	fi
else
	deno_install
fi
