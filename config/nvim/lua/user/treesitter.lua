local M = {}

function M.setup()
  local disabled = { 'lua', 'vim', 'help' }
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
      'lua',
      'php',
      'sql',
      'svelte',
      'typescript',
      'vimdoc',
      'vue',
      'zig',
    },
    highlight = {
      enable = true,
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end

        if vim.tbl_contains(disabled, lang) then
          return true
        end

        return false
      end,
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
