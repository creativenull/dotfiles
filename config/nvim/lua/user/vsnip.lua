local M = {}

-- Jump to the next snippet selection
-- or perform default key behaviour
local function jump_next(default_key)
  if vim.call('vsnip#jumpable', 1) == 1 then
    return '<Plug>(vsnip-jump-next)'
  else
    return default_key
  end
end

-- Jump to the previous snippet selection
-- or perform default key behaviour
local function jump_prev(default_key)
  if vim.call('vsnip#jumpable', -1) == 1 then
    return '<Plug>(vsnip-jump-prev)'
  else
    return default_key
  end
end

function M.setup()
  vim.g.vsnip_filetypes = {
    javascriptreact = { 'javascript' },
    typescriptreact = { 'typescript' },
  }

  local vsnip_next_key = '<C-j>'
  local vsnip_prev_key = '<C-k>'

  -- Navigate in insert mode
  vim.keymap.set('i', vsnip_next_key, function()
    return jump_next(vsnip_next_key)
  end, { expr = true, desc = 'Jump to next snippet from vsnip' })

  vim.keymap.set('i', vsnip_prev_key, function()
    return jump_prev(vsnip_prev_key)
  end, { expr = true, desc = 'Jump to previous snippet from vsnip' })

  -- Navigate in select mode
  vim.keymap.set('s', vsnip_next_key, function()
    return jump_next(vsnip_next_key)
  end, { expr = true, desc = 'Jump to next snippet from vsnip' })

  vim.keymap.set('s', vsnip_prev_key, function()
    return jump_prev(vsnip_prev_key)
  end, { expr = true, desc = 'Jump to previous snippet from vsnip' })
end

return M
