#!/bin/bash

echo '---'
echo 'Linking config files'
echo '---'

rm -rf ~/.config/kitty
ln -s ~/dotfiles/config/kitty ~/.config/

ln -s ~/dotfiles/gitconfig ~/.gitconfig
ln -s ~/dotfiles/zshrc ~/.zshrc
ln -s ~/dotfiles/config/zsh-plugins ~/.config/
ln -s ~/dotfiles/config/starship.toml ~/.config/starship.toml
ln -s ~/dotfiles/config/lsd ~/.config/
ln -s ~/dotfiles/config/nvim ~/.config/

echo ''
echo '---'
echo 'Linking npm packages and installing'
echo '---'
ln -s ~/dotfiles/npmrc ~/.npmrc
ln -s ~/dotfiles/default-npm-packages ~/.default-npm-packages
npm install -g $(cat ~/.default-npm-packages)

echo ''
echo '---'
echo 'Setting default shell to zsh'
echo '---'
chsh -s /bin/zsh
