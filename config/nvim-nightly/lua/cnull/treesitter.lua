require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'css',
    'go',
    'graphql',
    'html',
    'javascript',
    'jsdoc',
    'lua',
    'php',
    'tsx',
    'typescript',
    'vue',
  },
  highlight = { enable = true },
  indent = { enable = false },
  refactor = {
    highlight_definitions = { enable = true },
  },
})
