#!/bin/bash

echo '---'
echo 'Installing efm-langserver'
echo '---'
EFM_VER="v0.0.54"
EFM_URL="https://github.com/mattn/efm-langserver/releases/download/$EFM_VER/efm-langserver_${EFM_VER}_linux_amd64.tar.gz"
wget "$EFM_URL" -O ~/.local/bin/efm-langserver.tar.gz
tar -xzf ~/.local/bin/efm-langserver.tar.gz -C ~/.local/bin
rm ~/.local/bin/efm-langserver.tar.gz
mv ~/.local/bin/efm-langserver_${EFM_VER}_linux_amd64/efm-langserver ~/.local/bin
rm -rf ~/.local/bin/efm-langserver_${EFM_VER}_linux_amd64
