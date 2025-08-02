#!/usr/bin/env bash

echo '=> Installing neovim'

neovim_install() {
	sudo apt install -y ninja-build
	sudo apt install -y gettext
	sudo apt install -y python3-pip
	sudo apt install -y python3-wheel
	sudo apt install -y python-setuptools
	sudo apt install -y python3-pynvim

	NVIM_VER="v0.11.3"
	rm -rf ~/.builds/neovim
	git clone --depth 1 --branch $NVIM_VER https://github.com/neovim/neovim.git ~/.builds/neovim
	cd ~/.builds/neovim
	make distclean && make -j2 CMAKE_BUILD_TYPE=Release
	sudo make install
}

if [ -f /usr/bin/nvim ]; then
	read -p "=> nvim: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" = "y" ]; then
		neovim_install
	else
		echo "=> Skipping: nvim already installed"
	fi
else
	neovim_install
fi
