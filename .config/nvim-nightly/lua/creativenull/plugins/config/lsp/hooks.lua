local lsp_status = require 'lsp-status'
local buf_keymap = require 'creativenull.utils'.buf_keymap
local M = {}

-- LSP Buffer Keymaps
local function setup_keymaps(bufnr)
  buf_keymap(bufnr, 'i', '<C-y>', [[compe#confirm('<CR>')]], { expr = true })
  buf_keymap(bufnr, 'n', '<leader>lc', [[<cmd>Lspsaga rename<CR>]])
  buf_keymap(bufnr, 'n', '<leader>la', [[<cmd>Lspsaga code_action<CR>]])
  buf_keymap(bufnr, 'n', '<leader>ld', [[<cmd>lua vim.lsp.buf.definition()<CR>]])
  buf_keymap(bufnr, 'n', '<leader>le', [[<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>]])
  buf_keymap(bufnr, 'n', '<leader>lf', [[<cmd>lua vim.lsp.buf.formatting()<CR>]])
  buf_keymap(bufnr, 'n', '<leader>lh', [[<cmd>Lspsaga hover_doc<CR>]])
  buf_keymap(bufnr, 'n', '<leader>lw', [[<cmd>Lspsaga show_line_diagnostics<CR>]])
end

-- LSP on attach event
function M.on_attach(client, bufnr)
  lsp_status.on_attach(client)
  setup_keymaps(bufnr)
  print('Attached to ' .. client.name)
end

return M
