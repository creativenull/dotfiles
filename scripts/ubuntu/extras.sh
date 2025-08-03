#!/usr/bin/env bash
set -e

echo '---'
echo 'Starting extras script'
echo '---'

# From omakub/install.sh
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.session idle-delay 0

for script in $(ls $HOME/dotfiles/scripts/ubuntu/extras/*.sh); do
	sh "$script"
done

# From omakub/install.sh
gsettings set org.gnome.desktop.screensaver lock-enabled true
gsettings set org.gnome.desktop.session idle-delay 300
