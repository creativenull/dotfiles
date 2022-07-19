if vim.g.loaded_user_qflist ~= nil then
  return
end

vim.api.nvim_create_augroup('UserQFListEvents', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'UserQFListEvents',
  pattern = 'qf',
  callback = function()
    local buf = vim.api.nvim_get_current_buf()

    -- Close quickfix list or location list
    if not vim.tbl_isempty(vim.fn.getqflist()) then
      vim.keymap.set('n', '<CR>', '<CR>:cclose<CR>', { buffer = buf })
    else
      vim.keymap.set('n', '<CR>', '<CR>:lclose<CR>', { buffer = buf })
    end
  end,
  desc = 'Custom qflist keymaps',
})

vim.g.loaded_user_qflist = true
