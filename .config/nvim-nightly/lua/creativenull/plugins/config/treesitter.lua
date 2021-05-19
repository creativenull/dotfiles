require 'nvim-treesitter.configs'.setup {
    autopairs = {
        enable = true
    },
    ensure_installed = {
        'css',
        'graphql',
        'html',
        'javascript',
        'json',
        'lua',
        'python',
        'tsx',
        'typescript',
        'svelte'
    },
    highlight = { enable = true },
    indent = {
        enable = true,
        disable = {
            'svelte'
        }
    }
}
