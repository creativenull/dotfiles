#!/usr/bin/env bash

echo '---'
echo 'Installing stylua'
echo '---'

STYLUA_VER="v2.0.2"
STYLUA_URL="https://github.com/JohnnyMorganz/StyLua/releases/download/${STYLUA_VER}/stylua-linux-x86_64.zip"
stylua_install() {
	wget "$STYLUA_URL" -O ~/.local/bin/stylua.zip
	unzip ~/.local/bin/stylua.zip -d ~/.local/bin
	rm ~/.local/bin/stylua.zip
}

if command -v stylua &> /dev/null
then
	read -p "stylua: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" = "y" ]; then
		stylua_install
	else
		echo "Skipping"
	fi
else
	stylua_install
fi

echo '---'
echo 'Installing efm-langserver'
echo '---'

EFM_VER="v0.0.54"
EFM_URL="https://github.com/mattn/efm-langserver/releases/download/$EFM_VER/efm-langserver_${EFM_VER}_linux_amd64.tar.gz"
efm_install() {
	wget "$EFM_URL" -O ~/.local/bin/efm-langserver.tar.gz
	tar -xzf ~/.local/bin/efm-langserver.tar.gz -C ~/.local/bin
	rm ~/.local/bin/efm-langserver.tar.gz
	mv ~/.local/bin/efm-langserver_${EFM_VER}_linux_amd64/efm-langserver ~/.local/bin
	rm -rf ~/.local/bin/efm-langserver_${EFM_VER}_linux_amd64
}

if command -v efm-langserver &> /dev/null
then
	read -p "efm-langserver: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" = "y" ]; then
		efm_install
	else
		echo "Skipping"
	fi
else
	efm_install
fi

echo '---'
echo 'Installing deno'
echo '---'

deno_install() {
	curl -fsSL https://deno.land/install.sh | sh -s -- --yes --no-modify-path
}

if command -v deno &> /dev/null
then
	read -p "deno: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" = "y" ]; then
		deno_install
	else
		echo "Skipping: deno already installed"
	fi
else
	deno_install
fi

echo '---'
echo 'Install lua-language-server'
echo '---'

LUA_LANGUAGE_SERVER_VER="3.13.6"
luals_install() {
	asdf plugin add lua-language-server
	asdf install lua-language-server $LUA_LANGUAGE_SERVER_VER
	asdf set -u lua-language-server $LUA_LANGUAGE_SERVER_VER
}

if command -v lua-language-server &> /dev/null
then
	read -p "lua-language-server: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" = "y" ]; then
		luals_install
	else
		echo "Skipping: lua-language-server already installed"
	fi
else
	luals_install
fi
