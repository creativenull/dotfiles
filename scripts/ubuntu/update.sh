#!/usr/bin/env bash
set -e

echo '=> Updating apt packages'

if [ -x $(command -v nala) ]; then
	sudo nala update && sudo nala upgrade
else
	sudo apt update && sudo apt upgrade
fi

echo '=> Updating snap packages'

sudo snap refresh
