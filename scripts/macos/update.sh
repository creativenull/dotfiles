#!/usr/bin/env bash
set -euo pipefail

yes=0
for arg in "$@"; do
	case "$arg" in
		--yes) yes=1 ;;
	esac
done

printf "=> Updating packages\n"

printf "=> Checking for outdated brew packages\n"
brew update && brew outdated

echo "brew upgrade --yes"
if [ $yes -eq 1 ]; then
	brew upgrade --yes
else
	read -p "=> Run the above brew command? (y/N) " brew_choice
	if [ "$brew_choice" = "y" ]; then
		brew upgrade --yes
	fi
fi

printf "=> Checking for outdated npm packages\n"
npm outdated --global || true

echo "npm update --global"
if [ $yes -eq 1 ]; then
	npm update --global
else
	read -p "=> Run the above npm command? (y/N) " npm_choice
	if [ "$npm_choice" = "y" ]; then
		npm update --global
	fi
fi
