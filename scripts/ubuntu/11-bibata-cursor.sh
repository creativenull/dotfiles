#!/bin/bash

echo '---'
echo 'Installing Bibata-Modern-Classic cursor'
echo '---'

mkdir -p ~/.builds
BIBATA_VER="2.0.7"
BIBATA_URL="https://github.com/ful1e5/Bibata_Cursor/releases/download/v${BIBATA_VER}/Bibata-Modern-Classic.tar.xz"
wget "$BIBATA_URL" -O ~/.builds/bibata.tar.xz
tar -xJf ~/.builds/bibata.tar.xz -C ~/.local/share/icons
rm -f ~/.builds/bibata.tar.xz
