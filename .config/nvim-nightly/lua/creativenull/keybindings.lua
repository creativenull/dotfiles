local u = require 'creativenull.utils'

-- Leader
vim.g.mapleader = ' '

-- Unbind default bindings for arrow keys, trust me this is for your own good
u.vnoremap('<up>',    '<nop>')
u.vnoremap('<down>',  '<nop>')
u.vnoremap('<left>',  '<nop>')
u.vnoremap('<right>', '<nop>')

u.inoremap('<up>',    '<nop>')
u.inoremap('<down>',  '<nop>')
u.inoremap('<left>',  '<nop>')
u.inoremap('<right>', '<nop>')

-- Map Esc, to perform quick switching between Normal and Insert mode
u.inoremap('jk', '<ESC>')

-- Map escape from terminal input to Normal mode
u.tnoremap('<ESC>', [[<C-\><C-n>]])
u.tnoremap('<C-[>', [[<C-\><C-n>]])

-- Copy/Paste from the system clipboard
u.vnoremap('<C-i>', [["+y<CR>]])
u.nnoremap('<C-o>', [["+p<CR>]])

-- File explorer
u.nnoremap('<F3>', ':Ex<CR>')

-- Omnifunc
u.inoremap('<C-Space>', '<C-x><C-o>')

-- Disable highlights
u.nnoremap('<leader><CR>', ':noh<CR>')

-- Buffer maps
-- -----------
-- List all buffers
u.nnoremap('<leader>ba', ':buffers<CR>')
u.nnoremap('<leader>bn', ':enew<CR>')
u.nnoremap('<C-l>',      ':bnext<CR>')
u.nnoremap('<C-h>',      ':bprevious<CR>')
u.nnoremap('<leader>bd', ':bp<BAR>sp<BAR>bn<BAR>bd<CR>')

-- Resize window panes, we can use those arrow keys
-- to help use resize windows - at least we give them some purpose
u.nnoremap('<up>',    ':resize +2<CR>')
u.nnoremap('<down>',  ':resize -2<CR>')
u.nnoremap('<left>',  ':vertical resize -2<CR>')
u.nnoremap('<right>', ':vertical resize +2<CR>')

-- Text maps
-- ---------
-- Move a line of text Alt+[j/k]
u.nnoremap('<M-j>', [[mz:m+<CR>`z]])
u.nnoremap('<M-k>', [[mz:m-2<CR>`z]])
u.vnoremap('<M-j>', [[:m'>+<CR>`<my`>mzgv`yo`z]])
u.vnoremap('<M-k>', [[:m'<-2<CR>`>my`<mzgv`yo`z]])

-- Reload file
u.nnoremap('<leader>r', ':e!<CR>')

-- Reload config
u.nnoremap('<leader>vs', '<cmd>ConfigReload<CR><cmd>noh<CR><cmd>EditorConfigReload<CR>')

-- Telescope
u.nnoremap('<C-p>', [[<cmd>lua require'creativenull.plugins.config.telescope'.find_files()<CR>]])
u.nnoremap('<C-t>', [[<cmd>lua require'creativenull.plugins.config.telescope'.live_grep()<CR>]])
