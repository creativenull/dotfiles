# My nvim-nightly config

> DO NOT USE THIS CONFIG

> Check out my [original config I use for workd][nvim] or [my lua config that I experiment with modularity][nvim-config]
if you want to check try out a full stable lua version of nvim config.

[Adapted from my nvim-oneconfig][nvim-oneconfig] guide.

[Taken from my post on having two separate versions of neovim][post]

This is my nvim config with an aim to replace vim plugins with lua plugins (to an extent) and utilizing the builtin
lsp client in nvim. It's a [direct translation of my original config][nvim] with some differences. If you want a pure
lua config, check out my [nvim-config repo][nvim-config] which is a different take on structuring out a lua config.

To use this you must have a separate executable from normal `nvim` and must be from a compiled nvim binary cloned from
the neovim repository.

## Manually compile neovim

Install the [pre-requisites for building neovim first][nvim-prereq] and then:

```sh
git clone https://github.com/neovim/neovim.git $HOME/.builds/neovim && cd $HOME/.builds/neovim
```

```sh
make distclean && make CMAKE_BUILD_TYPE=RelWithDebInfo
```

## Create custom binary and add to $PATH

Create a binary file to be executable and add to the global path (assuming you're in a Linux enviornment):

```sh
touch $HOME/.local/bin/nv
```

```sh
chmod +x $HOME/.local/bin/nv
```

Inside `$HOME/.local/bin/nv` file, add the contents:

```sh
#!/usr/bin/sh
USERSPACE="nvim-nightly"
NVIM_GIT=${HOME}/.builds/neovim
NVIM_RPLUGIN_MANIFEST=${HOME}/.local/share/${USERSPACE}/rplugin.vim
VIMRUNTIME=${NVIM_GIT}/runtime
MYVIMRC=${HOME}/.config/${USERSPACE}/init.lua

MYVIMRC=${MYVIMRC} NVIM_RPLUGIN_MANIFEST=${NVIM_RPLUGIN_MANIFEST} VIMRUNTIME=${VIMRUNTIME} ${NVIM_GIT}/build/bin/nvim "$@" -u ${MYVIMRC}
```

Add `$HOME/.local/bin` to your `$PATH` if not already in your `$PATH`:

```sh
echo "export PATH=\$HOME/.local/bin:\$PATH" >> ~/.bash_profile
```

```sh
source ~/.bash_profile
```

For ZSH:

```sh
echo "export PATH=\$HOME/.local/bin:\$PATH" >> ~/.zprofile
```

```sh
source ~/.zprofile
```

## Copy config to local machine

Clone this repo and copy (or link with `ln -s`) `nvim-nightly` directory to the user config:

```sh
git clone https://github.com/creativenull/dotfiles.git $HOME/cnull-dotfiles
```

```sh
cp -rv $HOME/cnull-dotfiles/config/nvim-nightly $HOME/.config/nvim-nightly

# Or link
# ln -s $HOME/cnull-dotfiles/config/nvim-nightly $HOME/.config/nvim-nightly
```

## Running the nvim-nightly config

Executing `nv` from any directory should start to install plugins and setup nvim from the `nvim-nightly` config
directory.

[nvim-oneconfig]: https://github.com/creativenull/nvim-oneconfig
[nvim-config]: https://github.com/creativenull/nvim-config
[nvim]: https://github.com/creativenull/dotfiles/tree/main/.config/nvim
[nvim-prereq]: https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites
[post]: https://dev.to/creativenull/installing-neovim-nightly-alongside-stable-10d0
