echo '---'
echo 'Installing neovim'
echo '---'

if command -v nvim &> /dev/null
then
	echo "Skipping: neovim already installed"
	exit 0
fi

sudo apt install -y ninja-build gettext cmake curl build-essential

NVIM_VER="v0.10.4"
rm -rf ~/.builds/neovim
git clone --depth 1 --branch $NVIM_VER https://github.com/neovim/neovim.git ~/.builds/neovim
cd ~/.builds/neovim
make distclean && make -j2 CMAKE_BUILD_TYPE=Release
sudo make install
