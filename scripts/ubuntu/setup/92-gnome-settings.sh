#!/usr/bin/env bash

echo '=> Configuring system theme'

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'
gsettings set org.gnome.desktop.interface icon-theme 'Tela-dark'

echo '=> Configuring keyboard settings'

gsettings set org.gnome.desktop.peripherals.keyboard delay 250
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 15

gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape_shifted_capslock']"

echo '=> Configuring misc settings'

# Change emoji keyboard shortcut
gsettings set org.freedesktop.ibus.panel.emoji hotkey "['<Ctrl><Shift>e']"
