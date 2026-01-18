# Custom settings
# ---
export LANG=en_US.UTF-8
export EDITOR=nvim

# Make aliase for bat if batcat is found
if command -v batcat &> /dev/null; then
	alias bat="batcat"
fi

# System
alias ls="lsd -A"
alias ll="lsd -lA"
alias mkdir="mkdir -pv"
alias cp="cp -v"
alias open-ports="sudo ss -ltnp"
alias grep="grep --color=auto"

# Neovim
export PYTHON3_HOST_PROG=$(which python3)

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
alias gls="git log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short"
alias gi="git init; git add -A && git commit -m 'feat: init'"
alias gl="git pull"
alias gp="git push"
alias gre="git reset"
alias greh="git reset --hard HEAD"
alias gres="git reset --soft HEAD"
alias grs="git restore"
alias grss="git restore --staged"
alias grm="git remote"
alias grmao="git remote add origin"
alias gs="git status"
alias gst="git stash"
alias gt="git tag"

# Personal aliases
alias cddot="cd ~/dotfiles"
alias cdnvim="cd ~/dotfiles/config/nvim"
alias cdp="cd ~/projects/github.com/creativenull"
alias cdd="cd ~/projects/demos"

# zsh settings
# ---
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.deno/bin" ] ; then
    PATH="$HOME/.deno/bin:$PATH"
fi

# Tab and Shift Tab to auto complete
bindkey '^I' expand-or-complete
bindkey '^[[Z' reverse-menu-complete
bindkey '^N' expand-or-complete
bindkey '^P' reverse-menu-complete

bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

autoload -Uz compinit; compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

HISTFILE=~/.zsh_history

HISTSIZE=10000
SAVEHIST=10000

setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS

# Deno plugin
# ---
source ~/.config/zsh-plugins/zsh-deno/deno.plugin.zsh

# Autosuggestions plugin
# ---
source ~/.config/zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
bindkey '^ ' autosuggest-accept

# Syntax highlighting plugin
# ---
source ~/.config/zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

# History substring search plugin
# ---
source ~/.config/zsh-plugins/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh

if [ "$(uname)" != "Darwin" ]; then
	bindkey "$terminfo[kcuu1]" history-substring-search-up
	bindkey "$terminfo[kcud1]" history-substring-search-down
else
	bindkey '^[[A' history-substring-search-up
	bindkey '^[[B' history-substring-search-down
fi

# Laravel artisan plugin
# ---
source ~/.config/zsh-plugins/zsh-artisan/artisan.plugin.zsh

# Custom completions location
fpath=($HOME/.zsh/completions $fpath)
autoload -U compinit; compinit

# Starship
# ---
eval "$(starship init zsh)"
