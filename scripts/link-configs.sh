#!/usr/bin/env bash
set -e

echo '=> Linking config files'

# ---
# For all systems
# ---

rm -rf ~/.config/kitty
ln -sv ~/dotfiles/config/kitty ~/.config/

rm -fv ~/.gitconfig
rm -rfv ~/.config/git
ln -sv ~/dotfiles/config/git ~/.config/

rm -fv ~/.zshrc
ln -sv ~/dotfiles/zshrc ~/.zshrc

rm -rfv ~/.config/zsh-plugins
ln -sv ~/dotfiles/config/zsh-plugins ~/.config/

rm -fv ~/.tmux.conf
ln -sv ~/dotfiles/tmux.conf ~/.tmux.conf

rm -fv ~/.config/starship.toml
ln -sv ~/dotfiles/config/starship.toml ~/.config/starship.toml

rm -fv ~/.config/lsd
ln -sv ~/dotfiles/config/lsd ~/.config/

rm -fv ~/.config/nvim
ln -sv ~/dotfiles/config/nvim ~/.config/

rm -fv ~/.config/zellij
ln -sv ~/dotfiles/config/zellij ~/.config/

rm -fv ~/.config/goose
ln -sv ~/dotfiles/config/goose ~/.config/

rm -fv ~/.claude/settings.json
ln -sv ~/dotfiles/claude/settings.json ~/.claude/settings.json

rm -fv ~/.codex/config.toml
ln -sv ~/dotfiles/codex/config.toml ~/.codex/config.toml

# ---
# For macOS only
# ---

if [ "$(uname -s)" = "Darwin" ]; then
	rm -rfv ~/.hammerspoon
	ln -sv ~/dotfiles/hammerspoon ~/.hammerspoon
fi

# ---
# npm specific
# ---

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

# ---
# zsh specific (Linux)
# ---

if [ "$(uname -s)" = "Linux" ]; then
	read -p "Change default shell? (y/N) " choice

	if [ "$choice" = "y" ]; then
		echo '=> Setting default shell to zsh'
		chsh -s /bin/zsh
	fi
fi
