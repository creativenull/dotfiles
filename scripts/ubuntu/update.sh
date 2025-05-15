#!/usr/bin/env bash
set -e

echo '=> Updating apt packages'

sudo apt update && sudo apt upgrade

echo '=> Updating snap packages'

sudo snap refresh
