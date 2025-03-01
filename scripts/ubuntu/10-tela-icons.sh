#!/bin/bash

echo '---'
echo 'Install tela icons'
echo '---'

mkdir -p ~/.builds
git clone --depth 1 https://github.com/vinceliuice/Tela-icon-theme ~/.builds/Tela-icon-theme
. ~/.builds/Tela-icon-theme/install.sh
rm -rf ~/.builds/Tela-icon-theme
