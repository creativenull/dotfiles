require 'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'css',
    'html',
    'javascript',
    'typescript',
    'php',
    'lua',
    'vue',
  },
  highlight = { enable = true },
  indent = { enable = true },
}
