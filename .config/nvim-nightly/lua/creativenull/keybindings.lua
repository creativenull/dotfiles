local keymap = require 'creativenull.utils'.keymap

-- Leader
vim.g.mapleader = ' '

-- Unbind default bindings for arrow keys, trust me this is for your own good
keymap('v', '<up>', '<nop>')
keymap('v', '<down>', '<nop>')
keymap('v', '<left>', '<nop>')
keymap('v', '<right>', '<nop>')
keymap('i', '<up>', '<nop>')
keymap('i', '<down>', '<nop>')
keymap('i', '<left>', '<nop>')
keymap('i', '<right>', '<nop>')

-- Map Esc, to perform quick switching between Normal and Insert mode
keymap('i', 'jk', '<ESC>')

-- Map escape from terminal input to Normal mode
keymap('t', '<ESC>', [[<C-\><C-n>]])
keymap('t', '<C-[>', [[<C-\><C-n>]])

-- File explorer
keymap('n', '<F3>', '<Cmd>NnnPicker %:p:h<CR>')

-- Omnifunc
keymap('i', '<C-Space>', '<C-x><C-o>')

-- Disable highlights
keymap('n', '<leader><CR>', '<Cmd>noh<CR>')

-- Buffer maps
-- -----------
-- List all buffers
keymap('n', '<leader>bl', [[<Cmd>lua require'creativenull.plugins.config.telescope'.buffers()<CR>]])
-- Next buffer
keymap('n', '<C-l>', '<Cmd>bnext<CR>')
-- Previous buffer
keymap('n', '<C-h>', '<Cmd>bprevious<CR>')
-- Close buffer, and more?
keymap('n', '<leader>bd', '<Cmd>bp<BAR>sp<BAR>bn<BAR>bd<CR>')

-- Resize window panes, we can use those arrow keys
-- to help use resize windows - at least we give them some purpose
keymap('n', '<up>', '<Cmd>resize +2<CR>')
keymap('n', '<down>', '<Cmd>resize -2<CR>')
keymap('n', '<left>', '<Cmd>vertical resize -2<CR>')
keymap('n', '<right>', '<Cmd>vertical resize +2<CR>')

-- Text maps
-- ---------
-- Move a line of text Alt+[j/k]
keymap('n', '<M-j>', [[mz:m+<CR>`z]])
keymap('n', '<M-k>', [[mz:m-2<CR>`z]])
keymap('v', '<M-j>', [[:m'>+<CR>`<my`>mzgv`yo`z]])
keymap('v', '<M-k>', [[:m'<-2<CR>`>my`<mzgv`yo`z]])

-- Reload file
keymap('n', '<leader>r', '<Cmd>edit!<CR>')

-- Reload config
keymap('n', '<leader>vs', '<Cmd>ConfigReload<CR><Cmd>noh<CR><Cmd>EditorConfigReload<CR>')

-- Telescope
keymap('n', '<C-p>', [[<Cmd>lua require'creativenull.plugins.config.telescope'.find_files()<CR>]])
keymap('n', '<C-t>', [[<Cmd>lua require'creativenull.plugins.config.telescope'.live_grep()<CR>]])
keymap('n', '<leader>vf', [[<Cmd>lua require'creativenull.plugins.config.telescope'.find_config_files()<CR>]])
keymap('n', '<leader>ff', [[<Cmd>lua require'creativenull.plugins.config.telescope'.file_browser()<CR>]])
