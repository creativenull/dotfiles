#!/usr/bin/bash

# pre-requisites
sudo apt-get install \
    build-essential \
    git \
    curl \
    wget \
    ripgrep \
    xsel \
    zsh \
    kitty \
    software-properties-common \
    zip \
    unzip \
    autoconf \
    bison \
    gettext \
    libgd-dev \
    libcurl4-openssl-dev \
    libedit-dev \
    libicu-dev \
    libjpeg-dev \
    libmysqlclient-dev \
    libonig-dev \
    libpng-dev \
    libpq-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libzip-dev \
    openssl \
    pkg-config \
    re2c \
    zlib1g-dev

# lsd
lsd_url=https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd_0.23.1_amd64.deb
lsd_filepath=~/Downloads/lsd.deb
wget -O $lsd_filepath $lsd_url
sudo apt-get install $lsd_filepath
rm -v $lsd_filepath

# Neovim
nvim_url=https://github.com/neovim/neovim/releases/download/v0.8.0/nvim-linux64.deb
nvim_filepath=~/Downloads/nvim.deb
wget -O $nvim_filepath $nvim_url
sudo apt-get install $nvim_filepath
rm -v $nvim_filepath

# asdf install
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2

# rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# deno
curl -fsSL https://deno.land/install.sh | sh

# Linking config files
# ln -s ~/dotfiles/gitconfig ~/.gitconfig
# ln -s ~/dotfiles/zshrc ~/.zshrc
# ln -s ~/dotfiles/tmux-kitty.conf ~/.tmux.conf
# ln -s ~/dotfiles/config/kitty ~/.config/kitty
# ln -s ~/dotfiles/config/lsd ~/.config/lsd
# ln -s ~/dotfiles/config/alacritty ~/.config/alacritty
