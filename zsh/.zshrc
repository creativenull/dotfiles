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

# Editor paths and aliases
alias g="git"
alias v="nvim"
alias p="sudo pacman"
alias a="sudo apt"

# Git aliases
alias gs="git status"

alias ga="git add"
alias gA="git add -A"

alias gdu="git diff"
alias gds="git diff --staged"

alias gbr="git branch"
alias gco="git checkout"

alias gcm="git commit"

alias gp="git push"
alias gl="git pull"

alias gf="git fetch"

alias gh="git log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short"

# Android Environment Variables
export ANDROID_HOME=$HOME/.android-sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Programming projects paths
export PROJECTS=$HOME/projects
export C_PROJECTS=$PROJECTS/c-cpp-projects/c
export CPP_PROJECTS=$PROJECTS/c-cpp-projects/cpp
export RUST_PROJECTS=$PROJECTS/rust-projects
export PYTHON_PROJECTS=$PROJECTS/python-projects

# Go Environment Variables
export GOPATH=$PROJECTS/go
export PATH=$PATH:$GOPATH/bin

# Vim Python paths
export PYTHON_HOST_PROG=/usr/bin/python2
export PYTHON3_HOST_PROG=/usr/bin/python3

# NPM
export PATH=$PATH:$HOME/.npm-global/bin

# Gradle
export PATH=$PATH:/usr/local/android-studio/gradle/gradle-5.1.1/bin

# Add fzf settings for nvim
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# By default run tmux
[[ $TERM != "screen" ]] && exec tmux
