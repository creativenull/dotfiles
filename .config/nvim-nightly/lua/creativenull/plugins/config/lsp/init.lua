local completion = require 'completion'
local lsp = require 'lspconfig'
local lsp_status = require 'lsp-status'
local utils = require 'creativenull.utils'

-- Completion opts for LSP
local function completion_setup()
  completion.on_attach {
    confirm_key = [[<C-y>]],
    enable_snippet = 'UltiSnips',
    matching_smart_case = true,
    enable_auto_hover = false,
    enable_auto_signature = false
  }
end

local function on_attach(client, bufnr)
  print('Attached to ' .. client.name)
  completion_setup()
  lsp_status.on_attach(client)

  -- LSP diagnostics
  vim.cmd 'augroup lsp_diagnostic_popup'
  vim.cmd 'autocmd! * <buffer>'
  vim.cmd [[ au CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics() ]]
  vim.cmd [[ autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references() ]]
  vim.cmd 'augroup END'
end

function LSPOnAttach(client, bufnr)
  on_attach(client, bufnr)
end

lsp.tsserver.setup {
  on_attach = on_attach,
  capabilities = lsp_status.capabilities,
  root_dir = lsp.util.root_pattern('.tsserver')
}

--[[
lsp.denols.setup {
  on_attach = on_attach,
  capabilities = lsp_status.capabilities,
  init_options = {
    enable = true,
    unstable = true,
    importMap = './import_map.json'
  },
  root_dir = lsp.util.root_pattern('.denols')
}
--]]

--[[
lsp.vuels.setup {
  on_attach = on_attach,
  capabilities = lsp_status.capabilities,
  init_options = {
    config = {
      css = {},
      emmet = {},
      html = {
        suggest = {}
      },
      javascript = {
        format = {}
      },
      stylusSupremacy = {},
      typescript = {
        format = {}
      },
      vetur = {
        completion = {
          autoImport = false,
          tagCasing = "kebab",
          useScaffoldSnippets = false
        },
        format = {
          defaultFormatter = {
            js = "none",
            ts = "none"
          },
          defaultFormatterOptions = {},
          scriptInitialIndent = false,
          styleInitialIndent = false
        },
        useWorkspaceDependencies = false,
        validation = {
          script = true,
          style = true,
          template = false
        }
      }
    }
  }
}
--]]

lsp.jsonls.setup {
  on_attach = on_attach,
  capabilities = lsp_status.capabilities
}

lsp.intelephense.setup {
  on_attach = on_attach,
  capabilities = lsp_status.capabilities
}

local current_path = (...):gsub('%.init$', '')
require (current_path .. '.diagnosticls').setup {
  on_attach = on_attach,
  capabilities = lsp_status.capabilities
}
