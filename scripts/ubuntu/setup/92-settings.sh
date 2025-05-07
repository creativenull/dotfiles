#!/usr/bin/env bash

echo '---'
echo 'Configuring system theme'
echo '---'

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'
gsettings set org.gnome.desktop.interface icon-theme 'Tela-dark'

echo '---'
echo 'Configuring keyboard settings'
echo '---'

gsettings set org.gnome.desktop.peripherals.keyboard delay 250
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 15

gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape_shifted_capslock']"

echo '---'
echo 'Configuring misc settings'
echo '---'

# Change emoji keyboard shortcut
gsettings set org.freedesktop.ibus.panel.emoji hotkey "['<Ctrl><Shift>e']"
