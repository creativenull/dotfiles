#!/usr/bin/env bash

echo '=> Installing vivaldi'

VIVALDI_VER="7.5.3735.58-1"
VIVALDI_URL="https://downloads.vivaldi.com/stable/vivaldi-stable_${VIVALDI_VER}_amd64.deb"

mkdir -p ~/.builds
wget "$VIVALDI_URL" -O ~/.builds/vivaldi.deb
sudo dpkg -i ~/.builds/vivaldi.deb

rm -rf ~/.builds/vivaldi.deb
