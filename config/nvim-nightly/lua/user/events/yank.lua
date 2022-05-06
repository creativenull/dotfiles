-- Highlight characters on yank
local yank_user_events = vim.api.nvim_create_augroup('yank_user_events', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = yank_user_events,

  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 500 })
  end,

  desc = 'Highlight words on yank',
})

