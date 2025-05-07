#!/usr/bin/env bash
set -e

echo '---'
echo 'Starting setup script'
echo '---'

for script in $(ls $HOME/dotfiles/scripts/ubuntu/setup/*.sh); do
	sh "$script"
done
