local M = {
  plugins = {
    {'neovim/nvim-lspconfig'},
    {'creativenull/diagnosticls-configs-nvim'},
  },
}

function M.after()
  local nmap = require('cnull.core.keymap').nmap
  local corelsp = require('cnull.core.lsp')

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

  corelsp.init()
  corelsp.on_attach = on_attach
  require('cnull.lsp').setup({'javascript', 'json', 'lua', 'php', 'typescript'})

  local dlsconfig = require('diagnosticls-configs')
  dlsconfig.init({ on_attach = on_attach })
  dlsconfig.setup({
    lua = {
      linter = require('diagnosticls-configs.linters.luacheck'),
      formatter = require('diagnosticls-configs.formatters.lua_format'),
    },
    javascript = {
      linter = require('diagnosticls-configs.linters.eslint'),
      formatter = require('diagnosticls-configs.formatters.prettier'),
    },
    javascriptreact = {
      linter = require('diagnosticls-configs.linters.eslint'),
      formatter = require('diagnosticls-configs.formatters.prettier'),
    },
    typescript = {
      linter = require('diagnosticls-configs.linters.eslint'),
      formatter = require('diagnosticls-configs.formatters.prettier'),
    },
    typescriptreact = {
      linter = require('diagnosticls-configs.linters.eslint'),
      formatter = require('diagnosticls-configs.formatters.prettier'),
    },
    php = {
      linter = require('diagnosticls-configs.linters.phpcs'),
    }
  })
end

return M
