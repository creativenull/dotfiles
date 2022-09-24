require('nvim-treesitter.configs').setup({
  ensure_installed = { 'javascript', 'typescript', 'php', 'css', 'html', 'go', 'zig', 'astro', 'lua' },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
})

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
