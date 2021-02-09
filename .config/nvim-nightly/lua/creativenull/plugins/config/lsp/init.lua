local current_path = (...):gsub('%.init$', '')
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

local function on_attach(client)
    print('Attached to ' .. client.name)
    completion_setup()
    lsp_status.on_attach(client)

    -- LSP diagnostics
    vim.cmd 'augroup lsp_diagnostics_view'
    vim.cmd 'au!'
    vim.cmd [[au CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()]]
    vim.cmd 'augroup end'
end

lsp.tsserver.setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
    root_dir = lsp.util.root_pattern('.tsserver')
}

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
