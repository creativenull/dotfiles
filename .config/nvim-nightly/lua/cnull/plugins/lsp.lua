local core = require('cnull.core')
local nmap = core.keymap.nmap

local M = {
  plugins = {
    {'neovim/nvim-lspconfig'},
    {'creativenull/diagnosticls-nvim', requires = {'neovim/nvim-lspconfig'}},
  },
}

function M.after()
  local function on_attach(_, bufnr)
    local diag_opts = '{ width = 80, focusable = false, border = "single" }'

    -- Keymaps
    nmap('<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { bufnr = bufnr })
    nmap('<Leader>ld', '<Cmd>lua vim.lsp.buf.definition()<CR>', { bufnr = bufnr })
    nmap('<Leader>le', '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', { bufnr = bufnr })
    nmap('<Leader>lf', '<Cmd>lua vim.lsp.buf.formatting()<CR>', { bufnr = bufnr })
    nmap('<Leader>lh', '<Cmd>lua vim.lsp.buf.hover()<CR>', { bufnr = bufnr })
    nmap('<Leader>lr', '<Cmd>lua vim.lsp.buf.rename()<CR>', { bufnr = bufnr })
    nmap('<Leader>lw', '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics('.. diag_opts ..')<CR>', { bufnr = bufnr })
  end

  core.lsp.init()
  core.lsp.on_attach = on_attach

  require('cnull.lsp').setup({'javascript', 'json', 'lua', 'php', 'typescript'})

  local dls = require('diagnosticls-nvim')
  dls.init({ on_attach = on_attach })
  dls.setup {
    lua = {
      linter = require 'diagnosticls-nvim.linters.luacheck',
      formatter = require 'diagnosticls-nvim.formatters.lua_format',
    },
    javascript = {
      linter = require 'diagnosticls-nvim.linters.eslint',
      formatter = require 'diagnosticls-nvim.formatters.prettier',
    },
    javascriptreact = {
      linter = require 'diagnosticls-nvim.linters.eslint',
      formatter = require 'diagnosticls-nvim.formatters.prettier',
    },
    typescript = {
      linter = require 'diagnosticls-nvim.linters.eslint',
      formatter = require 'diagnosticls-nvim.formatters.prettier',
    },
    typescriptreact = {
      linter = require 'diagnosticls-nvim.linters.eslint',
      formatter = require 'diagnosticls-nvim.formatters.prettier',
    },
  }
end

return M
