local core = require 'cnull.core'
local nmap = core.keymap.nmap

local function on_attach(client, bufnr)
  -- Autocompletion
  -- vim.fn['deoplete#enable']()
  -- vim.fn['deoplete#custom#option'] {
  --   auto_complete_delay = 50,
  --   ignore_case = true,
  --   max_list = 10,
  --   smart_case = true,
  --   sources = { ['_'] = { 'lsp', 'ultisnips' } },
  -- }

  -- Keymaps
  nmap('<leader>l[', [[<Cmd>Lspsaga diagnostic_jump_prev<CR>]], { bufnr = bufnr })
  nmap('<leader>l]', [[<Cmd>Lspsaga diagnostic_jump_next<CR>]], { bufnr = bufnr })
  nmap('<leader>la', [[<Cmd>Lspsaga code_action<CR>]], { bufnr = bufnr })
  nmap('<leader>ld', [[<Cmd>lua vim.lsp.buf.definition()<CR>]], { bufnr = bufnr })
  nmap('<leader>le', [[<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>]], { bufnr = bufnr })
  nmap('<leader>lf', [[<Cmd>lua vim.lsp.buf.formatting()<CR>]], { bufnr = bufnr })
  nmap('<leader>lh', [[<Cmd>Lspsaga hover_doc<CR>]], { bufnr = bufnr })
  nmap('<leader>lr', [[<Cmd>Lspsaga rename<CR>]], { bufnr = bufnr })
  nmap('<leader>lw', [[<Cmd>Lspsaga show_line_diagnostics<CR>]], { bufnr = bufnr })
end

core.lsp.init()
core.lsp.set_on_attach(on_attach)
require 'cnull.lsp'.setup {
  'javascript',
  'json',
  'lua',
  'php',
  'typescript',
}
