local nmap = require 'cnull.core.keymap'.nmap

vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob !.git'
vim.env.FZF_DEFAULT_OPTS = '--reverse'
vim.g.fzf_preview_window = {}

nmap('<C-p>', [[<Cmd>Files<CR>]])
nmap('<C-t>', [[<Cmd>Rg<CR>]])
