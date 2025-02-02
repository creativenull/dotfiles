# ZSH Plugins

## Updating

```sh
git fetch <remote_name>
```

Full commands (need to find a way to automate it):

```sh
git fetch zsh-artisan && \
git subtree pull --prefix zsh-artisan zsh-artisan master && \
git fetch zsh-autosuggestions && \
git subtree pull --prefix zsh-autosuggestions zsh-autosuggestions master && \
git fetch zsh-syntax-highlighting && \
git subtree pull --prefix zsh-syntax-highlighting zsh-syntax-highlighting master && \
git getch zsh-history-substring-search && \
git subtree pull --prefix zsh-history-substring-search zsh-history-substring-search master
```
