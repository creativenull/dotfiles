require 'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'html',
    'css',
    'json',
    'javascript',
    'typescript',
    'python',
    'lua',
    'tsx'
  },
  highlight = {
    enable = true
  }
}
