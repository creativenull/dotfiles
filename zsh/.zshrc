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

# Python host prog for vim
export PYTHON3_HOST_PROG='/usr/bin/python3'
export PYTHON_HOST_PROG='/usr/bin/python2'

# Editor paths and aliases
alias g="git"
alias v="nvim"
alias p="sudo pacman"
alias a="sudo apt"

# Git aliases
alias gs="git status"
alias ga="git add"
alias gA="git add -A"
alias gd="git diff"
alias gds="git diff --staged"
alias gbr="git branch"
alias gco="git checkout"
alias gcm="git commit"
alias gp="git push"
alias gl="git pull"
alias gf="git fetch"
alias gro="git remote"
alias gre="git reset --hard HEAD"
alias gh="git log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short"

# Add fzf settings for nvim
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# By default run tmux
[[ $TERM != "screen" ]] && exec tmux
