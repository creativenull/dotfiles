#!/usr/bin/env bash

echo '=> Installing core packages'

sudo nala install -y autoconf
sudo nala install -y bat
sudo nala install -y btop
sudo nala install -y cmake
sudo nala install -y httpie
sudo nala install -y ripgrep
sudo nala install -y software-properties-common
sudo nala install -y unzip
sudo nala install -y vim
sudo nala install -y zip
sudo nala install -y zsh

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
