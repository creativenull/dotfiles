#!/usr/bin/env bash

echo '=> Creating ~/.local/bin and add to $PATH'

mkdir -p ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"

echo '=> System update'

sudo apt update && sudo apt upgrade -y
sudo snap refresh
