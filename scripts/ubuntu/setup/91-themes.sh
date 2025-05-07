#!/usr/bin/env bash

echo '=> Installing fonts, icons and themes'

JETBRAINS_NF_VER="v3.3.0"
JETBRAINS_NF_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${JETBRAINS_NF_VER}/JetBrainsMono.zip"
mkdir -p ~/.local/share/fonts
rm -rf ~/.local/share/fonts/JetBrainsMono
wget "$JETBRAINS_NF_URL" -O ~/.builds/JetBrainsMono.zip
unzip ~/.builds/JetBrainsMono.zip -d ~/.local/share/fonts
rm ~/.builds/JetBrainsMono.zip

TELA_ICONS_GIT_URL="https://github.com/vinceliuice/Tela-icon-theme.git"
git clone --depth 1 $TELA_ICONS_GIT_URL ~/.builds/Tela-icon-theme
sudo ~/.builds/Tela-icon-theme/install.sh
rm -rf ~/.builds/Tela-icon-theme

BIBATA_CURSOR_VER="v2.0.7"
BIBATA_CURSOR_URL="https://github.com/ful1e5/Bibata_Cursor/releases/download/${BIBATA_CURSOR_VER}/Bibata-Modern-Classic.tar.xz"
wget "$BIBATA_CURSOR_URL" -O ~/.builds/Bibata-Modern-Classic.tar.xz
sudo rm -rf /usr/share/icons/Bibata-Modern-Classic
sudo tar -xvf ~/.builds/Bibata-Modern-Classic.tar.xz -C /usr/share/icons
rm ~/.builds/Bibata-Modern-Classic.tar.xz

echo '=> Configuring theme for snap packages'

sudo snap install bibata-all-cursor
for plug in $(snap connections | grep gtk-common-themes:icon-themes | awk '{print $2}'); do sudo snap connect ${plug} bibata-all-cursor:icon-themes; done
