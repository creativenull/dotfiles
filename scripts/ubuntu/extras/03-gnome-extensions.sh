#!/usr/bin/env bash

echo '=> Installing gnome extensions'

echo '=> blur-my-shell'

BLURMYSHELL_VERSION="v68-2"
BLURMYSHELL_UUID="blur-my-shell@aunetx"
BLURMYSHELL_URL="https://github.com/aunetx/blur-my-shell/releases/download/${BLURMYSHELL_VERSION}/${BLURMYSHELL_UUID}.shell-extension.zip"

TOPHAT_VERSION="v22"
TOPHAT_UUID="tophat@fflewddur.github.io"
TOPHAT_URL="https://github.com/fflewddur/tophat/releases/download/${TOPHAT_VERSION}/${TOPHAT_UUID}.${TOPHAT_VERSION}.shell-extension.zip"

PAPERWM_VERSION="48.0.2"
PAPERWM_UUID="paperwm@paperwm.github.io"
PAPERWM_URL="https://github.com/paperwm/PaperWM/archive/refs/tags/v${PAPERWM_VERSION}.zip"

if [ "$1" = "enable" ]; then
	gnome-extensions enable "${BLURMYSHELL_UUID}"
    gnome-extensions enable "${TOPHAT_UUID}"
    gnome-extensions enable "${PAPERWM_UUID}"

	exit 0
fi

blurmyshell_install() {
	if [ -d ~/.local/share/gnome-shell/extensions/${BLURMYSHELL_UUID} ]; then
		gnome-extensions uninstall "${BLURMYSHELL_UUID}"
	fi

	wget "$BLURMYSHELL_URL" -O ~/.builds/blur-my-shell.zip
	mkdir -p ~/.local/share/gnome-shell/extensions/${BLURMYSHELL_UUID}
	unzip ~/.builds/blur-my-shell.zip -d ~/.local/share/gnome-shell/extensions/${BLURMYSHELL_UUID}

	rm -rf ~/.builds/blur-my-shell.zip
}

if [ -d ~/.local/share/gnome-shell/extensions/${BLURMYSHELL_UUID} ]; then
	read -p "=> gnome-extensions/blur-my-shell: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" = "y" ]; then
		blurmyshell_install
	else
		echo "=> Skipping"
	fi
else
	blurmyshell_install
fi

echo '=> tophat'

tophat_install() {
	if [ -d ~/.local/share/gnome-shell/extensions/${TOPHAT_UUID} ]; then
		gnome-extensions uninstall "${TOPHAT_UUID}"
	fi

	wget "$TOPHAT_URL" -O ~/.builds/tophat.zip
	mkdir -p ~/.local/share/gnome-shell/extensions/${TOPHAT_UUID}
	unzip ~/.builds/tophat.zip -d ~/.local/share/gnome-shell/extensions/${TOPHAT_UUID}

	rm -rf ~/.builds/tophat.zip
}

if [ -d ~/.local/share/gnome-shell/extensions/${TOPHAT_UUID} ]; then
	read -p "=> gnome-extensions/tophat: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" = "y" ]; then
		tophat_install
	else
		echo "=> Skipping"
	fi
else
	tophat_install
fi

echo '=> paperwm'

paperwm_install() {
	if [ -d ~/.local/share/gnome-shell/extensions/${PAPERWM_UUID} ]; then
		gnome-extensions uninstall "${PAPERWM_UUID}"
	fi

	wget "$PAPERWM_URL" -O ~/.builds/paperwm.zip
	unzip ~/.builds/paperwm.zip -d ~/.builds
	. ~/.builds/PaperWM-${PAPERWM_VERSION}/install.sh

	rm ~/.builds/paperwm.zip
}

if [ -d ~/.local/share/gnome-shell/extensions/${PAPERWM_UUID} ]; then
	read -p "=> gnome-extensions/paperwm: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" = "y" ]; then
		paperwm_install
	else
		echo "=> Skipping"
	fi
else
	paperwm_install
fi
