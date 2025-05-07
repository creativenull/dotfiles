#!/usr/bin/env bash
set -e

echo '---'
echo 'Updating apt packages'
echo '---'

sudo apt update && sudo apt upgrade

echo '---'
echo 'Updating snap packages'
echo '---'

sudo snap refresh
