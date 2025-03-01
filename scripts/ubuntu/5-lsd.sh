#!/bin/bash

echo '---'
echo 'Installing lsd'
echo '---'
LSD_VER="1.1.5"
LSD_URL="https://github.com/lsd-rs/lsd/releases/download/v${LSD_VER}/lsd_${LSD_VER}_amd64.deb"
wget "$STYLUA_URL" -O ~/.local/bin/lsd.deb
sudo dpkg -i ~/.local/bin/lsd.deb
rm -f ~/.local/bin/lsd.deb
