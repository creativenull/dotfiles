#!/usr/bin/env bash
set -e

echo '=> Linking config files'

rm -rf ~/.config/kitty
ln -sv ~/dotfiles/config/kitty ~/.config/

rm -fv ~/.gitconfig
rm -rfv ~/.config/git
ln -sv ~/dotfiles/config/git ~/.config/

rm -fv ~/.zshrc
ln -sv ~/dotfiles/zshrc ~/.zshrc

rm -rfv ~/.config/zsh-plugins
ln -sv ~/dotfiles/config/zsh-plugins ~/.config/

rm -fv ~/.config/starship.toml
ln -sv ~/dotfiles/config/starship.toml ~/.config/starship.toml

rm -fv ~/.config/lsd
ln -sv ~/dotfiles/config/lsd ~/.config/

rm -fv ~/.config/nvim
ln -sv ~/dotfiles/config/nvim ~/.config/

echo '=> Linking npm packages and installing'

rm -fv ~/.npmrc
ln -s ~/dotfiles/npmrc ~/.npmrc

rm -fv ~/.default-npm-packages
ln -s ~/dotfiles/default-npm-packages ~/.default-npm-packages

read -p "Install global npm packages? (y/N) " choice

if [ "$choice" = "y" ]; then
    if [ -x "$(command -v npm)" ]; then
	npm install -g $(cat ~/.default-npm-packages)
    fi
fi

read -p "Change default shell? (y/N) " choice

if [ "$choice" = "y" ]; then
    echo '=> Setting default shell to zsh'
    chsh -s /bin/zsh
fi
