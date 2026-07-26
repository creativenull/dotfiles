#!/usr/bin/env bash
set -euo pipefail

yes=0
for arg in "$@"; do
	case "$arg" in
		--yes) yes=1 ;;
	esac
done

printf "=> Updating packages\n"

if [ $yes -eq 1 ]; then
	sudo apt update && sudo apt upgrade --yes
else
	read -p "=> Run apt update and upgrade? (y/N) " apt_choice
	if [ "$apt_choice" = "y" ]; then
		sudo apt update && sudo apt upgrade --yes
	fi
fi

printf "=> Checking for outdated brew packages\n"
brew update && brew outdated

if [ $yes -eq 1 ]; then
	brew upgrade --yes
else
	read -p "=> Run brew upgrade? (y/N) " brew_choice
	if [ "$brew_choice" = "y" ]; then
		brew upgrade --yes
	fi
fi

printf "=> Checking for outdated npm packages\n"
npm outdated --global --prefer-online --min-release-age=0 || true

if [ $yes -eq 1 ]; then
	npm update --global --prefer-online --min-release-age=0
else
	read -p "=> Run npm update? (y/N) " npm_choice
	if [ "$npm_choice" = "y" ]; then
		npm update --global --prefer-online --min-release-age=0
	fi
fi
