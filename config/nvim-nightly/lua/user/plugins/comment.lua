local lazyLoadCommentPluginGroup = vim.api.nvim_create_augroup('lazyLoadCommentPluginGroup', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Lazy load comment',
  group = lazyLoadCommentPluginGroup,
  once = true,

  callback = function()
    vim.cmd([[
      packadd Comment.nvim
      luafile ~/.local/share/nvim-nightly/site/pack/paq/opt/Comment.nvim/after/plugin/Comment.lua
      lua require('Comment').setup()
    ]])
  end,
})
