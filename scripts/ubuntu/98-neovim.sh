#!/bin/bash

echo '---'
echo 'Installing neovim'
echo '---'
NVIM_VER="v0.10.4"
git clone --depth 1 --branch $NVIM_VER https://github.com/neovim/neovim.git ~/.builds/neovim
sudo apt-get install -y ninja-build gettext cmake
cd ~/.builds/neovim
make distclean && make -j2 CMAKE_BUILD_TYPE=Release
sudo make install
