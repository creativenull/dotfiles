local M = {}

local pumgroup = vim.api.nvim_create_augroup('UserPumLspGroup', {})

---Statusline component to check if the LSP server connected to the buffer
---@return string
function _G.LspInfoStatusline()
  local bufnr = vim.api.nvim_get_current_buf()
  local results = vim.lsp.buf_get_clients(bufnr)

  if #results > 0 then
    return 'LSP '
  else
    return ''
  end
end

---@param client table
---@param bufnr number
local function on_attach(client, bufnr)
  -- Omnifunc backup
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- LSP Keymaps
  vim.keymap.set('n', '<Leader>la', vim.lsp.buf.code_action, { desc = 'LSP Code Actions', buffer = bufnr })
  vim.keymap.set('n', '<Leader>ld', vim.lsp.buf.definition, { desc = 'LSP Go-to Definition', buffer = bufnr })
  vim.keymap.set('n', '<Leader>lh', vim.lsp.buf.hover, { desc = 'LSP Hover Information', buffer = bufnr })
  vim.keymap.set('n', '<Leader>lr', vim.lsp.buf.rename, { desc = 'LSP Rename', buffer = bufnr })
  vim.keymap.set('n', '<Leader>ls', vim.lsp.buf.signature_help, { desc = 'LSP Signature Help', buffer = bufnr })
  vim.keymap.set('n', '<Leader>le', vim.diagnostic.setloclist, { desc = 'LSP Show All Diagnostics', buffer = bufnr })
  vim.keymap.set('n', '<Leader>lw', function()
    vim.diagnostic.open_float({ bufnr = bufnr, scope = 'line' })
  end, { desc = 'Show LSP Line Diagnostic', buffer = bufnr })

  -- LSP Formatting keymap only from the following linter/formatter servers
  -- Ref: https://github.com/neovim/nvim-lspconfig/wiki/Multiple-language-servers-FAQ
  local allowed_fmt_servers = { 'diagnosticls', 'efm', 'null-ls', 'denols' }

  if vim.tbl_contains(allowed_fmt_servers, client.name) then
    local desc = string.format('LSP Formatting with %s', client.name)

    vim.keymap.set('n', '<Leader>lf', function()
      client.request('textDocument/formatting', vim.lsp.util.make_formatting_params({}), nil, bufnr)
    end, { desc = desc, buffer = bufnr })
  end

  -- pum.vim Configuration for completion item resolve
  -- ---
  if
    client.server_capabilities.completionProvider and client.server_capabilities.completionProvider.resolveProvider
  then
    vim.api.nvim_create_autocmd('User', {
      group = pumgroup,
      pattern = 'PumCompleteDone',
      callback = function()
        local completed_item = vim.g['pum#completed_item']
        client.request('completionItem/resolve', vim.fn.json_decode(completed_item.user_data.lspitem), function(_, res)
          if res.additionalTextEdits then
            vim.lsp.util.apply_text_edits(res.additionalTextEdits, bufnr, 'utf-8')
          end
        end)
      end,
    })
  end
end

function M.setup()
  vim.keymap.set('n', '<Leader>li', '<Cmd>LspInfo<CR>')

  -- Add support to get snippets from lsp
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.preselectSupport = true
  capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    },
  }

  -- UI options
  local width = 80
  local border = 'rounded'

  -- Gloabally change diagnostic behavior
  -- turn them off so that ALE can handle diagnostics
  -- exclusively
  vim.diagnostic.config({
    underline = false,
    virtual_text = false,
    signs = false,
    update_in_insert = false,
    float = {
      source = true,
      width = width,
      border = border,
    },
  })

  -- Hover options
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    width = width,
    border = border,
  })

  -- Signature help options
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

  -- projectlocal-vim Config
  -- ---
  local projectlocal = require('projectlocal.lsp')
  projectlocal.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Log debug
  -- vim.lsp.set_log_level('DEBUG')
end

return M
