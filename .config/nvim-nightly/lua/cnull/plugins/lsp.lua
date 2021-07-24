local core = require 'cnull.core'
local nmap = core.keymap.nmap

local M = {
  plugins = {
    {'neovim/nvim-lspconfig'},
    {'glepnir/lspsaga.nvim', requires = {'neovim/nvim-lspconfig'}},
    {'creativenull/diagnosticls-nvim', requires = {'neovim/nvim-lspconfig'}},
  },
}

function M.after()
  local function on_attach(_, bufnr)
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

  local diagls = require 'diagnosticls-nvim'
  diagls.init { on_attach = on_attach }
  diagls.setup {
    lua = {
      linter = require 'diagnosticls-nvim.linters.luacheck',
      formatter = require 'diagnosticls-nvim.formatters.lua_format',
    },
    -- javascript = {
    --   linter = require 'diagnosticls-nvim.linters.eslint',
    --   formatter = require 'diagnosticls-nvim.formatters.prettier',
    -- },
    -- javascriptreact = {
    --   linter = require 'diagnosticls-nvim.linters.eslint',
    --   formatter = require 'diagnosticls-nvim.formatters.prettier',
    -- },
    -- typescript = {
    --   linter = require 'diagnosticls-nvim.linters.eslint',
    --   formatter = require 'diagnosticls-nvim.formatters.prettier',
    -- },
    -- typescriptreact = {
    --   linter = require 'diagnosticls-nvim.linters.eslint',
    --   formatter = require 'diagnosticls-nvim.formatters.prettier',
    -- },
  }
end

return M
