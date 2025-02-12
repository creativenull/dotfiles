# Custom settings
# ---
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR=nvim
else
	export EDITOR=nvim
fi

# System
alias ls="lsd -A"
alias ll="lsd -lA"
alias mkdir="mkdir -pv"
alias cp="cp -v"

# Vim
export PYTHON3_HOST_PROG=/usr/bin/python3
export PYTHON_HOST_PROG=/usr/bin/python2
alias v=nvim

# Git aliases
alias g="git"
alias gA="git add -A"
alias ga="git add"
alias gbr="git branch"
alias gcl="git clone"
alias gcm="git commit"
alias gco="git checkout"
alias gm="git merge"
alias gd="git diff"
alias gds="git diff --staged"
alias gf="git fetch"
alias gh="git log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short"
alias gi="git init"
alias gl="git pull"
alias gp="git push"
alias gre="git reset --hard HEAD"
alias grs="git restore"
alias gro="git remote"
alias gs="git status"
alias gst="git stash"
alias gt="git tag"

# PHP
alias art="php artisan"
alias sf="php bin/console"

# zsh settings
# ---
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

HISTFILE=~/.zsh_history

HISTSIZE=10000
SAVEHIST=10000

setopt SHARE_HISTORY

source ~/.config/zsh-plugins/zsh-deno/deno.plugin.zsh

source ~/.config/zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
bindkey '^ ' autosuggest-accept

source ~/.config/zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

source ~/.config/zsh-plugins/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

source ~/.config/zsh-plugins/zsh-artisan/artisan.plugin.zsh

# Starship
# ---
eval "$(starship init zsh)"
