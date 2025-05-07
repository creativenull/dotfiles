#!/usr/bin/env bash

echo '---'
echo 'Creating ~/.local/bin and add to $PATH'
echo '---'

mkdir -p ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"

echo '---'
echo 'System update'
echo '---'

sudo apt update && sudo apt upgrade -y
sudo snap refresh
