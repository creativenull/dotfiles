local lsp = require 'lspconfig'
local lsp_status = require 'lsp-status'
local completion = require 'completion'
local u = require 'creativenull.utils'
local M = {}

local function register_completion()
  completion.on_attach {
    confirm_key = [[<C-y>]],
    enable_snippet = 'UltiSnips',
    matching_smart_case = true,
    enable_auto_hover = false,
    enable_auto_signature = false
  }
end

local function register_buf_keymaps()
  u.buf_nnoremap('<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>')
  u.buf_nnoremap('<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  u.buf_nnoremap('<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>')
  u.buf_nnoremap('<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>')
  u.buf_nnoremap('<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  u.buf_nnoremap('<leader>le', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
  u.buf_nnoremap('<F2>',       '<cmd>lua vim.lsp.buf.rename()<CR>')
end

local function register_cursorhold_event()
  vim.cmd 'augroup lsp_diagnostic_popup'
  vim.cmd 'au!'
  vim.cmd 'au CursorHold  <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()'
  vim.cmd 'au CursorMoved <buffer> lua vim.lsp.buf.clear_references()'
  vim.cmd 'augroup end'
end

local function on_attach(client, bufnr)
  print('Attached to ' .. client.name)
  lsp_status.on_attach(client)
  register_completion()
  register_buf_keymaps()
  register_cursorhold_event()
end

-- TODO
-- Move this function to projectcmd.nvim for integrated nvim-lsp support
-- Register lsp for projectcmd.nvim plugin
_G.RegisterLsp = function(lsp_name, opts)
  local default_opts = {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities
  }

  if lsp[lsp_name] == nil then
    vim.api.nvim_err_writeln(' "' .. lsp_name .. '" does not exist in nvim-lspconfig')
    return
  end

  if opts ~= nil and not vim.tbl_isempty(opts) then
    -- Merge opts, if keys are the same, then prioritize opts
    lsp[lsp_name].setup(vim.tbl_extend('force', default_opts, opts))
  else
    lsp[lsp_name].setup(default_opts)
  end
end

-- Examples below, it don't hurt nobody

--[[
lsp.tsserver.setup {
  on_attach = on_attach,
  capabilities = lsp_status.capabilities
}
--]]

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

--[[
lsp.jsonls.setup {
  on_attach = on_attach,
  capabilities = lsp_status.capabilities
}
--]]

--[[
lsp.intelephense.setup {
  on_attach = on_attach,
  capabilities = lsp_status.capabilities
}
--]]

--[[
local current_path = (...):gsub('%.init$', '')
require (current_path .. '.diagnosticls').setup {
  on_attach = on_attach,
  capabilities = lsp_status.capabilities
}
--]]
