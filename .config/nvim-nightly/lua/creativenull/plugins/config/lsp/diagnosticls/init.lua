local current_path = (...):gsub('%.init$', '')
local eslint = require (current_path .. '.linters.eslint')
local prettier = require (current_path .. '.formatters.prettier')
local prettier_standard = require (current_path .. '.formatters.prettier_standard')
local lsp = require 'lspconfig'
local M = {}

function M.setup(lsp_opts)
  lsp.diagnosticls.setup {
    on_attach = lsp_opts.on_attach,
    capabilities = lsp_opts.capabilities,
    root_dir = lsp.util.root_pattern('.git'),
    filetypes = {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact'
    },
    init_options = {
      filetypes = {
        javascript = 'eslint',
        javascriptreact = 'eslint'
      },
      formatFiletypes = {
        javascript = 'prettier',
        javascriptreact = 'prettier',
        typescript = 'prettier',
        typescriptreact = 'prettier'
      },
      linters = {
        eslint = eslint
      },
      formatters = {
        prettier_standard = prettier_standard,
        prettier = prettier
      }
    }
  }
end

return M
