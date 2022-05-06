-- Highlight characters on yank
local yankUserGroup = vim.api.nvim_create_augroup('yankUserGroup', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = yankUserGroup,

  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 500 })
  end,

  desc = 'Highlight words on yank',
})
