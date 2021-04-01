local utils = require 'creativenull.utils'

-- Leader
vim.g.mapleader = ' '

-- Unbind default bindings for arrow keys, trust me this is for your own good
utils.keymap('v', '<up>',    '<nop>')
utils.keymap('v', '<down>',  '<nop>')
utils.keymap('v', '<left>',  '<nop>')
utils.keymap('v', '<right>', '<nop>')

utils.keymap('i', '<up>',    '<nop>')
utils.keymap('i', '<down>',  '<nop>')
utils.keymap('i', '<left>',  '<nop>')
utils.keymap('i', '<right>', '<nop>')

-- Map Esc, to perform quick switching between Normal and Insert mode
utils.keymap('i', 'jk', '<ESC>')

-- Map escape from terminal input to Normal mode
utils.keymap('t', '<ESC>', [[<C-\><C-n>]])
utils.keymap('t', '<C-[>', [[<C-\><C-n>]])

-- Copy/Paste from the system clipboard
-- Use at your own risk
-- utils.keymap('v', '<C-i>', [["+y<CR>]])
-- utils.keymap('n', '<C-o>', [["+p<CR>]])

-- File explorer
utils.keymap('n', '<F3>', '<cmd>Ex<CR>')

-- Omnifunc
utils.keymap('i', '<C-Space>', '<C-x><C-o>')

-- Disable highlights
utils.keymap('n', '<leader><CR>', '<cmd>noh<CR>')

-- Buffer maps
-- -----------
-- List all buffers
utils.keymap('n', '<leader>ba', '<cmd>buffers<CR>')
-- Next buffer
utils.keymap('n', '<C-l>',      '<cmd>bnext<CR>')
-- Previous buffer
utils.keymap('n', '<C-h>',      '<cmd>bprevious<CR>')
-- Close buffer, and more?
utils.keymap('n', '<leader>bd', '<cmd>bp<BAR>sp<BAR>bn<BAR>bd<CR>')

-- Resize window panes, we can use those arrow keys
-- to help use resize windows - at least we give them some purpose
utils.keymap('n', '<up>',    '<cmd>resize +2<CR>')
utils.keymap('n', '<down>',  '<cmd>resize -2<CR>')
utils.keymap('n', '<left>',  '<cmd>vertical resize -2<CR>')
utils.keymap('n', '<right>', '<cmd>vertical resize +2<CR>')

-- Text maps
-- ---------
-- Move a line of text Alt+[j/k]
utils.keymap('n', '<M-j>', [[mz:m+<CR>`z]])
utils.keymap('n', '<M-k>', [[mz:m-2<CR>`z]])
utils.keymap('v', '<M-j>', [[:m'>+<CR>`<my`>mzgv`yo`z]])
utils.keymap('v', '<M-k>', [[:m'<-2<CR>`>my`<mzgv`yo`z]])

-- Reload file
utils.keymap('n', '<leader>r', '<cmd>edit!<CR>')

-- Reload config
utils.keymap('n', '<leader>vs', '<cmd>ConfigReload<CR><cmd>noh<CR><cmd>EditorConfigReload<CR>')

-- Telescope
utils.keymap('n', '<C-p>', [[<cmd>lua require'creativenull.plugins.config.telescope'.find_files()<CR>]])
utils.keymap('n', '<C-t>', [[<cmd>lua require'creativenull.plugins.config.telescope'.live_grep()<CR>]])
utils.keymap('n', '<leader>vf', [[<cmd>lua require'creativenull.plugins.config.telescope'.find_config_files()<CR>]])
