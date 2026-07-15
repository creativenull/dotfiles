#!/usr/bin/env bash
set -euo pipefail

printf "=> Updating packages\n"

read -p "=> Run apt upgrade? (y/N) " apt_choice
if [ "$apt_choice" = "y" ]; then
	sudo apt update && sudo apt upgrade --yes
fi

printf "=> Checking for outdated brew packages\n"
brew update && brew outdated

read -p "=> Run brew upgrade? (y/N) " brew_choice
if [ "$brew_choice" = "y" ]; then
    brew upgrade
fi

printf "=> Checking for outdated npm packages\n"
npm outdated --global --prefer-online --min-release-age=0 || true

read -p "=> Run npm update? (y/N) " npm_choice
if [ "$npm_choice" = "y" ]; then
    npm update --global --prefer-online --min-release-age=0
fi
