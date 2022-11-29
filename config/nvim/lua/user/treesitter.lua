local M = {}

function M.setup()
  local parser_install_dir = vim.fn.stdpath('data') .. '/treesitter'
  vim.opt.runtimepath:append(parser_install_dir)

  require('nvim-treesitter.configs').setup({
    parser_install_dir = parser_install_dir,
    ensure_installed = {
      'astro',
      'css',
      'go',
      'html',
      'javascript',
      'json',
      'php',
      'typescript',
      'vue',
      'zig',
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    incremental_selection = { enable = false },
  })

  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufAdd', 'BufNew', 'BufNewFile', 'BufWinEnter' }, {
    group = vim.g.user.event,
    callback = function()
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    end,
  })
end

return M
