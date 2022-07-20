local M = {}

local function confirm(default)
  if vim.call('ddc#map#pum_visible') == 1 then
    if vim.call('vsnip#expandable') == 1 then
      return [[\<Plug>(vsnip-expand)]]
    else
      return vim.call('pum#map#confirm')
    end
  end

  return default
end

function M.Setup()
  -- Keymaps
  vim.keymap.set('i', '<C-n>', 'pum#map#insert_relative(+1)', { expr = true })
  vim.keymap.set('i', '<C-p>', 'pum#map#insert_relative(-1)', { expr = true })
  vim.keymap.set('i', '<C-e>', 'pum#map#cancel()', { expr = true })
  vim.keymap.set('i', '<C-y>', function()
    return confirm([[\<C-y>]])
  end, { expr = true, desc = 'Insert selected completion item and close menu' })

  -- Events
  vim.api.nvim_create_augroup('UserPumEvents', { clear = true })
  vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = function()
      vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'NONE' })
    end,
    desc = 'No bg color for completion menu',
  })
end

return M
