#!/bin/bash

echo 'Symlinking dotfiles'
ln -s ~/dotfiles/gitconfig ~/.gitconfig
ln -s ~/dotfiles/zshrc ~/.zshrc
ln -s ~/dotfiles/config/zsh-plugins ~/.config/
ln -s ~/dotfiles/config/starship.toml ~/.config/starship.toml
ln -s ~/dotfiles/config/kitty ~/.config/
ln -s ~/dotfiles/config/lsd ~/.config/
ln -s ~/dotfiles/config/nvim ~/.config/

echo 'Installing npm packages'
ln -s ~/dotfiles/default-npm-packages ~/.default-npm-packages
npm install -g $(cat ~/.default-npm-packages)

echo 'Set shell to zsh'
chsh -s /bin/zsh
