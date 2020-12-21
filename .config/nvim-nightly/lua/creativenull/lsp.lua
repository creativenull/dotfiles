local lsp_status = require('lsp-status')
local lsp = require('lspconfig')
local completion = require('completion')

-- Register LSP-specific keys
local function set_lsp_keymaps()
    nnoremap('<F2>',       '<cmd>lua vim.lsp.buf.rename()<CR>')
    nnoremap('<leader>lm', '<cmd>lua vim.lsp.diagnostic.code_action()<CR>')
    nnoremap('<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>')
    nnoremap('<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
    nnoremap('<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>')
    nnoremap('<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>')
    nnoremap('<leader>le', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
end

local function completion_setup()
    completion.on_attach {
        confirm_key = [[<C-y>]],
        enable_snippet = 'UltiSnips',
        matching_smart_case = true,
        enable_auto_hover = false,
        enable_auto_signature = false,
    }
end

local function on_attach(client)
    print('Attached to ' .. client.name)
    set_lsp_keymaps()

    -- Completion
    completion_setup()

    -- Statusline
    lsp_status.on_attach(client)

    -- LSP
    vim.cmd [[autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()]]
end

-- TS/JS LSP
lsp.tsserver.setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities
}

-- Vue LSP
lsp.vuels.setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities
}

-- JSON LSP
lsp.jsonls.setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities
}

-- Vim LSP
lsp.vimls.setup{
    on_attach = on_attach,
    capabilities = lsp_status.capabilities
}

-- Intelephense LSP
lsp.intelephense.setup{
    on_attach = on_attach,
    capabilities = lsp_status.capabilities
}

-- Lua LSP
lsp.sumneko_lua.setup {
    cmd = { 'luals' },
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
    settings = {
        Lua = {
            runtime = {
                version = 'Lua 5.1'
            },
            diagnostics = {
                globals = {
                    'vim',
                    'use',
                    'imap',
                    'nmap',
                    'vmap',
                    'tmap',
                    'inoremap',
                    'nnoremap',
                    'vnoremap',
                    'tnoremap'
                }
            },
            workspace = {
                library = {
                    ['$VIMRUNTIME/lua'] = true,
                }
            }
        }
    }
}

-- Diagnostic LSP
local eslint = require('creativenull.diagnosticls.linters.eslint')
local prettier = require('creativenull.diagnosticls.formatters.prettier')
local prettier_standard = require('creativenull.diagnosticls.formatters.prettier_standard')
lsp.diagnosticls.setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
    filetypes = {
        'javascript',
        'javascriptreact'
    },
    init_options = {
        filetypes = {
            javascript = 'eslint',
            javascriptreact = 'eslint'
        },
        formatFiletypes = {
            javascript = 'prettier',
            javascriptreact = 'prettier'
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
