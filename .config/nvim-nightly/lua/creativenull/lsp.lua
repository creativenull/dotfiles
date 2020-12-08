local lsp_status = require('lsp-status')
local lsp = require('lspconfig')

local function LSPRegisterKeys()
    nnoremap('<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>')
    nnoremap('<leader>lm', '<cmd>lua vim.lsp.diagnostic.code_action()<CR>')
    nnoremap('<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>')
    nnoremap('<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
    nnoremap('<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>')
    nnoremap('<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>')
    nnoremap('<leader>le', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
end

local function on_attach(client)
    print('Attached to ' .. client.name)
    lsp_status.on_attach(client)
    require('completion').on_attach(client)

    LSPRegisterKeys()
    imap('<C-Space>', '<Plug>(completion_trigger)')
    vim.cmd('autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()')
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
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
    cmd = { 'luals' },
    settings = {
        Lua = {
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

local eslint = require('creativenull.linters.eslint')
local prettier = require('creativenull.formatters.prettier')
local prettier_standard = require('creativenull.formatters.prettier_standard')
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
