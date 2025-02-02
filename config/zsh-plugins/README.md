# ZSH Plugins

## First time init

```sh
git remote add <remote_name> <remote_url>
git subtree add --prefix=config/zsh-plugins/<plugin_name> <remote_name> <branch_name> --squash
```

## Updating

```sh
git fetch <remote_name>
git subtree pull --prefix=config/zsh-plugins/<plugin_name> <remote_name> <branch_name> --squash
```
