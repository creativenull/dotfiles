local M = {}

M.config = function()
  require'nvim-treesitter.configs'.setup {
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
      'svelte',
    },
    highlight = {
      enable = true
    }
  }
end

return M
