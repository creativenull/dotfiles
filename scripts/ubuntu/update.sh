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

read -p "Update kitty? (y/N) " choice

if [ "$choice" = "y" ]; then
    echo '---'
    echo 'Updating kitty'
    echo '---'

    rm -rf ~/.local/kitty.app

    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
    mkdir -p ~/.local/share/applications
    cp -f ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
    cp -f ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
    sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
fi

read -p "Update asdf? (y/N) " choice

if [ "$choice" = "y" ]; then
    echo '---'
    echo 'Updating asdf'
    echo '---'

    rm -rf ~/.local/bin/asdf

    ASDF_VER="v0.16.7"
    ASDF_URL="https://github.com/asdf-vm/asdf/releases/download/${ASDF_VER}/asdf-${ASDF_VER}-linux-amd64.tar.gz"
    wget "$ASDF_URL" -O ~/.local/bin/asdf.tar.gz
    tar -xzf ~/.local/bin/asdf.tar.gz -C ~/.local/bin
    rm ~/.local/bin/asdf.tar.gz
    export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fi

read -p "Update starship? (y/N) " choice

if [ "$choice" = "y" ]; then
    echo '---'
    echo 'Updating starship'
    echo '---'

    rm -rf ~/.local/bin/starship

    STARSHIP_VER="v1.22.1"
    STARSHIP_URL="https://github.com/starship/starship/releases/download/${STARSHIP_VER}/starship-x86_64-unknown-linux-gnu.tar.gz"
    wget "$STARSHIP_URL" -O ~/.local/bin/starship.tar.gz
    tar -xzf ~/.local/bin/starship.tar.gz -C ~/.local/bin
    rm ~/.local/bin/starship.tar.gz
fi

read -p "Update lsd? (y/N) " choice

if [ "$choice" = "y" ]; then
    echo '---'
    echo 'Updating lsd'
    echo '---'

    rm -rf ~/.local/bin/lsd

    LSD_VER="v1.1.5"
    LSD_URL="https://github.com/lsd-rs/lsd/releases/download/${LSD_VER}/lsd-${LSD_VER}-x86_64-unknown-linux-gnu.tar.gz"
    wget "$LSD_URL" -O ~/.local/bin/lsd.tar.gz
    tar -xzf ~/.local/bin/lsd.tar.gz -C ~/.local/bin
    rm ~/.local/bin/lsd.tar.gz
    mv -v ~/.local/bin/lsd-${LSD_VER}-x86_64-unknown-linux-gnu/lsd ~/.local/bin
    rm -rf ~/.local/bin/lsd-${LSD_VER}-x86_64-unknown-linux-gnu
fi

read -p "Update stylua? (y/N) " choice

if [ "$choice" = "y" ]; then
    echo '---'
    echo 'Updating stylua'
    echo '---'

    rm -rf ~/.local/bin/stylua

    STYLUA_VER="v2.0.2"
    STYLUA_URL="https://github.com/JohnnyMorganz/StyLua/releases/download/${STYLUA_VER}/stylua-linux-x86_64.zip"
    wget "$STYLUA_URL" -O ~/.local/bin/stylua.zip
    unzip ~/.local/bin/stylua.zip -d ~/.local/bin
    rm ~/.local/bin/stylua.zip
fi

read -p "Update efm-langserver? (y/N) " choice

if [ "$choice" = "y" ]; then
    echo '---'
    echo 'Updating efm-langserver'
    echo '---'

    rm -rf ~/.local/bin/efm-langserver

    EFM_VER="v0.0.54"
    EFM_URL="https://github.com/mattn/efm-langserver/releases/download/$EFM_VER/efm-langserver_${EFM_VER}_linux_amd64.tar.gz"
    wget "$EFM_URL" -O ~/.local/bin/efm-langserver.tar.gz
    tar -xzf ~/.local/bin/efm-langserver.tar.gz -C ~/.local/bin
    rm ~/.local/bin/efm-langserver.tar.gz
    mv ~/.local/bin/efm-langserver_${EFM_VER}_linux_amd64/efm-langserver ~/.local/bin
    rm -rf ~/.local/bin/efm-langserver_${EFM_VER}_linux_amd64
fi

read -p "Update deno? (y/N) " choice

if [ "$choice" = "y" ]; then
    echo '---'
    echo 'Updating deno'
    echo '---'

    deno upgrade
fi
