local utils = require 'creativenull.utils'

-- Leader
vim.g.mapleader = ' '

-- Unbind default bindings for arrow keys, trust me this is for your own good
utils.vnoremap('<up>',    '<nop>')
utils.vnoremap('<down>',  '<nop>')
utils.vnoremap('<left>',  '<nop>')
utils.vnoremap('<right>', '<nop>')

utils.inoremap('<up>',    '<nop>')
utils.inoremap('<down>',  '<nop>')
utils.inoremap('<left>',  '<nop>')
utils.inoremap('<right>', '<nop>')

-- Map Esc, to perform quick switching between Normal and Insert mode
utils.inoremap('jk', '<ESC>')

-- Map escape from terminal input to Normal mode
utils.tnoremap('<ESC>', [[<C-\><C-n>]])
utils.tnoremap('<C-[>', [[<C-\><C-n>]])

-- Copy/Paste from the system clipboard
utils.vnoremap('<C-i>', [["+y<CR>]])
utils.nnoremap('<C-o>', [["+p<CR>]])

-- File explorer
utils.nnoremap('<F3>', ':Ex<CR>')

-- Omnifunc
utils.inoremap('<C-Space>', '<C-x><C-o>')

-- Disable highlights
utils.nnoremap('<leader><CR>', ':noh<CR>')

-- Buffer maps
-- -----------
-- List all buffers
utils.nnoremap('<leader>ba', ':buffers<CR>')
utils.nnoremap('<leader>bn', ':enew<CR>')
utils.nnoremap('<C-l>',      ':bnext<CR>')
utils.nnoremap('<C-h>',      ':bprevious<CR>')
utils.nnoremap('<leader>bd', ':bp<BAR>sp<BAR>bn<BAR>bd<CR>')

-- Resize window panes, we can use those arrow keys
-- to help use resize windows - at least we give them some purpose
utils.nnoremap('<up>',    ':resize +2<CR>')
utils.nnoremap('<down>',  ':resize -2<CR>')
utils.nnoremap('<left>',  ':vertical resize -2<CR>')
utils.nnoremap('<right>', ':vertical resize +2<CR>')

-- Text maps
-- ---------
-- Move a line of text Alt+[j/k]
utils.nnoremap('<M-j>', [[mz:m+<CR>`z]])
utils.nnoremap('<M-k>', [[mz:m-2<CR>`z]])
utils.vnoremap('<M-j>', [[:m'>+<CR>`<my`>mzgv`yo`z]])
utils.vnoremap('<M-k>', [[:m'<-2<CR>`>my`<mzgv`yo`z]])

-- Reload file
utils.nnoremap('<leader>r', ':e!<CR>')

-- Reload config
utils.nnoremap('<leader>vs', ':luafile $MYVIMRC<CR>')

-- Telescope
utils.nnoremap('<C-p>', [[<cmd>lua require'creativenull.plugins.config.telescope'.find_files()<CR>]])
utils.nnoremap('<C-t>', [[<cmd>lua require'creativenull.plugins.config.telescope'.live_grep()<CR>]])

-- LSP
utils.nnoremap('<leader>lm', '<cmd>lua vim.lsp.diagnostic.code_action()<CR>')
utils.nnoremap('<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>')
utils.nnoremap('<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
utils.nnoremap('<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>')
utils.nnoremap('<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>')
utils.nnoremap('<leader>le', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
utils.nnoremap('<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>')
