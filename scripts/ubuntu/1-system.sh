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
    bat \
    zip \
    unzip \
    python3-pip \
    python3-venv \
    python3-pynvim

echo '---'
echo 'Creating local bin directory'
echo '---'
mkdir -p ~/.local/bin
