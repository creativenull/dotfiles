# Oh my zsh configs
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='nvim'
else
	export EDITOR='nvim'
fi

# List alias
alias l="ls -lah"

# Directory colors (WSL Only)
eval `dircolors ~/.dircolors`

# neovim
export PYTHON3_HOST_PROG=/usr/bin/python3
export PYTHON_HOST_PROG=/usr/bin/python2
export NVIMRC_CONFIG_DIR=$HOME/.config/nvim
export NVIMRC_PLUGINS_DIR=$HOME/.local/share/nvim/plugged

# Global aliases
alias v="nvim"

# Git aliases
alias g="git"
alias gA="git add -A"
alias ga="git add"
alias gbr="git branch"
alias gcl="git clone"
alias gcm="git commit"
alias gco="git checkout"
alias gd="git diff"
alias gds="git diff --staged"
alias gf="git fetch"
alias gh="git log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short"
alias gi="git init && git checkout -b main"
alias gl="git pull"
alias gp="git push"
alias gre="git reset --hard HEAD"
alias grs="git restore"
alias gro="git remote"
alias gs="git status"
alias gst="git stash"
alias gt="git tag"

# By default run tmux
[[ $TERM != "screen" ]] && exec tmux
