#!/usr/bin/env bash
set -e

echo '---'
echo 'Starting setup script'
echo '---'

xcode-select --install

echo '---'
echo 'Installing Homebrew'
echo '---'

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

echo '---'
echo 'Installing brew packages via Brewfile'
echo '---'

brew bundle install --file $HOME/dotfiles/scripts/macos/Brewfile
