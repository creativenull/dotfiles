#!/usr/bin/bash

# Oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Artisan completions
git clone https://github.com/jessarcher/zsh-artisan.git ~/.oh-my-zsh/custom/plugins/artisan

# Asdf plugins
asdf add-plugin nodejs
asdf install nodejs lts
asdf reshim nodejs
asdf global nodejs lts

php_ver=8.1.12
asdf add-plugin php
asdf install php $php_ver
asdf global php $php_ver

# Enable yarn and pnpm
corepack enable

# Install editors tools
npm install -g \
    typescript-language-server \
    @volar/vue-language-server \
    typescript \
    prettier \
    eslint_d \
    intelephense \
    vscode-langservers-extracted
