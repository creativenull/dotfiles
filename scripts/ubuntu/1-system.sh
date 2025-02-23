#!/bin/bash

echo '---'
echo 'Installing updates'
echo '---'
sudo apt-get update && sudo apt-get upgrade -y

echo '---'
echo 'Installing packages'
echo '---'
sudo apt-get install -y \
    build-essential \
    autoconf \
    curl \
    wget \
    zsh \
    ripgrep \
    lsd \
    bat \
    zip \
    unzip \
    python3-pip \
    python3-venv \
    python3-pynvim

echo '---'
echo 'Adding ~/.local/bin to $PATH'
echo '---'
mkdir -p ~/.local/bin
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
export PATH="$HOME/.local/bin:$PATH"
