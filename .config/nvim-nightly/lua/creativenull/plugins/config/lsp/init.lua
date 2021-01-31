local current_path = (...):gsub('%.init$', '')
local completion = require 'completion'
local lsp = require 'lspconfig'
local lsp_status = require 'lsp-status'
local utils = require 'creativenull.utils'

-- Key-bindings set only when a LSP is registered
local function set_lsp_keymaps()
    utils.nnoremap('<leader>lm', '<cmd>lua vim.lsp.diagnostic.code_action()<CR>')
    utils.nnoremap('<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>')
    utils.nnoremap('<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
    utils.nnoremap('<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>')
    utils.nnoremap('<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>')
    utils.nnoremap('<leader>le', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
    utils.nnoremap('<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>')
end

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

local function on_attach(client)
    print('Attached to ' .. client.name)
    set_lsp_keymaps()
    completion_setup()
    lsp_status.on_attach(client)

    -- Register hold event to show diagnostic errors/warnings
    vim.cmd [[autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()]]
end

lsp.tsserver.setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
    root_dir = lsp.util.root_pattern('.tsserver')
}

lsp.denols.setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
    root_dir = lsp.util.root_pattern('.denols')
}

lsp.vuels.setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities
}

lsp.jsonls.setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities
}

lsp.intelephense.setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities
}

require (current_path .. '.diagnosticls').setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities
}
