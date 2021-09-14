# My Neovim Config

This is my main stable neovim config, I use this for work and make sure it is as stable as possible with plugins that
are battle tested and ready for development.

If you want a pure lua setup check out my [nvim-nightly config][nightly], for my experimental and lua centric config for
development.

## Current Startup Time

__Disclaimer__, these startup times are not the single source of truth to estimate vim plugins, whether written in
vimscript, lua, or other third party language.

```
Machine Specs
---
Processor: AMD A8-5557M APU
Memory: 12GB
Storage: Crucial SSD 500GB

Average Startup Time w/o file (ran 3 times)
---
nvim --startuptime nvim.log
Results: 169, 172, 174 = 171.67ms

Average Startup Time w/ file (ran 3 times)
---
nvim --startuptime nvim.log init.vim
Results: 430, 429, 432 = 430.33ms
```

[nightly]: https://github.com/creativenull/dotfiles/tree/main/.config/nvim-nightly
