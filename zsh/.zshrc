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
alias v="nvim"
alias vim="nvim"
alias gv="nvim-qt"
alias p="sudo pacman"

# Games path
export GAMES=$HOME/Games

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

[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
