-- local lspconfig_util = require('lspconfig/util')
local lsp_status = require('lsp-status')

local on_attach = function(client)
    lsp_status.on_attach(client)
    require('completion').on_attach(client)

    vim.cmd('autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()')
    vim.cmd('call LSP_RegisterKeys()')
    vim.cmd('imap <C-Space> <Plug>(completion_trigger)')
end

-- LSP Status
lsp_status.register_progress()

-- Bufferline
require('bufferline').setup()

-- Treesitter
require('nvim-treesitter/configs').setup {
    ensure_installed = 'all',
    highlight = { enable = true },
}

-- Telescope
local telescope = require('telescope')
local telescope_actions = require('telescope.actions')
telescope.setup {
    defaults = {
        mappings = {
            i = {
                ['<C-k>'] = telescope_actions.move_selection_previous,
                ['<C-j>'] = telescope_actions.move_selection_next,
            }
        }
    }
}

-- Gitsign
require('gitsigns').setup()

-- LSP Setups
-- ==========
-- TypeScript LSP
local lsp = require('lspconfig')

lsp.tsserver.setup {
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
}

-- Vue LSP
lsp.vuels.setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
}

-- JSON LSP
lsp.jsonls.setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
}

-- Vim LSP
lsp.vimls.setup{
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
}

-- Intelephense LSP
lsp.intelephense.setup{
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
}

-- Lua LSP
lsp.sumneko_lua.setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
    cmd = { 'luals' },
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = {
                library = {
                    ['$VIMRUNTIME/lua'] = true,
                },
            },
        },
    },
}

-- Diagnostic LSP
local eslint = require('./linters/eslint')
local prettier = require('./formatters/prettier')
local prettier_standard = require('./formatters/prettier_standard')
lsp.diagnosticls.setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
    filetypes = {
        'javascript',
        'javascriptreact',
    },
    init_options = {
        filetypes = {
            javascript = 'eslint',
            javascriptreact = 'eslint',
        },
        formatFiletypes = {
            javascript = 'prettier',
            javascriptreact = 'prettier',
        },
        linters = {
            eslint = eslint,
        },
        formatters = {
            prettier_standard = prettier_standard,
            prettier = prettier,
        },
    },
}
