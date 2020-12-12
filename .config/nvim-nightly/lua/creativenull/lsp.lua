local lsp_status = require('lsp-status')
local lsp = require('lspconfig')
local completion = require('completion')

local function lsp_register_keys()
    nnoremap('<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>')
    nnoremap('<leader>lm', '<cmd>lua vim.lsp.diagnostic.code_action()<CR>')
    nnoremap('<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>')
    nnoremap('<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
    nnoremap('<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>')
    nnoremap('<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>')
    nnoremap('<leader>le', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
end

local function completion_setup(client)
    vim.g.completion_confirm_key = [[ <C-y> ]]
    vim.g.completion_matching_smart_case = 1
    vim.g.completion_enable_snippet = 'UltiSnips'
    vim.g.completion_trigger_keyword_length = 3
    completion.on_attach(client)
end

local function on_attach(client)
    print('Attached to ' .. client.name)

    -- Statusline
    lsp_status.on_attach(client)

    -- Completion
    completion_setup(client)

    -- LSP
    vim.cmd [[ autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics() ]]
    lsp_register_keys()
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
