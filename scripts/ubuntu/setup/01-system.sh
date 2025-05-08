#!/usr/bin/env bash

echo '=> Installing core packages'

sudo apt install -y autoconf
sudo apt install -y bat
sudo apt install -y build-essential
sudo apt install -y cmake
sudo apt install -y curl
sudo apt install -y gnome-shell-extension-manager
sudo apt install -y gnome-tweaks
sudo apt install -y ripgrep
sudo apt install -y software-properties-common
sudo apt install -y unzip
sudo apt install -y vim
sudo apt install -y wget
sudo apt install -y zip
sudo apt install -y zsh

sudo snap install --stable vivaldi

echo '=> Installing lsd'

LSD_VER="v1.1.5"
LSD_URL="https://github.com/lsd-rs/lsd/releases/download/${LSD_VER}/lsd-${LSD_VER}-x86_64-unknown-linux-gnu.tar.gz"
lsd_install() {
	wget "$LSD_URL" -O ~/.local/bin/lsd.tar.gz
	tar -xzf ~/.local/bin/lsd.tar.gz -C ~/.local/bin
	rm ~/.local/bin/lsd.tar.gz
	mv -v ~/.local/bin/lsd-${LSD_VER}-x86_64-unknown-linux-gnu/lsd ~/.local/bin
	rm -rf ~/.local/bin/lsd-${LSD_VER}-x86_64-unknown-linux-gnu
}

if [ -f ~/.local/bin/lsd ]; then
	read -p "=> lsd: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" != "y" ]; then
		echo "=> Skipping"
	else
		lsd_install
	fi
else
	lsd_install
fi
