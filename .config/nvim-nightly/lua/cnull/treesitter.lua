require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'css',
    'graphql',
    'html',
    'javascript',
    'lua',
    'php',
    'typescript',
    'tsx',
    'vue',
    'go',
    'jsdoc'
  },
  highlight = { enable = true },
  indent = { enable = true },
  refactor = {
    highlight_definitions = { enable = true },
  },
})
