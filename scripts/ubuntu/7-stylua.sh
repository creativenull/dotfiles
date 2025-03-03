#!/bin/bash

echo '---'
echo 'Installing stylua'
echo '---'
STYLUA_URL="https://github.com/JohnnyMorganz/StyLua/releases/download/v2.0.2/stylua-linux-x86_64.zip"
wget "$STYLUA_URL" -O ~/.local/bin/stylua.zip
unzip ~/.local/bin/stylua.zip -d ~/.local/bin
rm ~/.local/bin/stylua.zip
