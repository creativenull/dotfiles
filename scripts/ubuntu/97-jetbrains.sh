#!/bin/bash

echo '---'
echo 'Installing jetbrains mono nerdfonts'
echo '---'
mkdir -p ~/.local/share/fonts
JETBRAINS_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip"
wget "$JETBRAINS_URL" -O ~/.local/share/fonts/JetBrainsMono.zip
unzip ~/.local/share/fonts/JetBrainsMono.zip -d ~/.local/share/fonts
rm ~/.local/share/fonts/JetBrainsMono.zip
