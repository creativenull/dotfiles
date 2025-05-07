echo '---'
echo 'Installing neovim'
echo '---'

neovim_install() {
	sudo apt install -y ninja-build gettext cmake curl build-essential

	NVIM_VER="v0.11.1"
	rm -rf ~/.builds/neovim
	git clone --depth 1 --branch $NVIM_VER https://github.com/neovim/neovim.git ~/.builds/neovim
	cd ~/.builds/neovim
	make distclean && make -j2 CMAKE_BUILD_TYPE=Release
	sudo make install
}

if command -v nvim &> /dev/null
then
	read -p "nvim: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" = "y" ]; then
		nvim_install
	else
		echo "Skipping: nvim already installed"
	fi
else
	nvim_install
fi
