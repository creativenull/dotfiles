local M = {}

function M.setup()
  local nc = require('neocodeium')
  vim.keymap.set('i', '<Tab>', nc.accept)
  vim.keymap.set('i', '<C-]>', function()
    nc.cycle(1)
  end)
  vim.keymap.set('i', '<C-[>', function()
    nc.cycle(-1)
  end)
  vim.keymap.set('i', '<C-x>', function()
    nc.clear()
  end)

  nc.setup({
    debounce = true,
    silent = true,
    filetypes = {
      ['fern-replacer'] = false,
    },
  })
end

return M
