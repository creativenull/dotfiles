local augroup = require('cnull.core.event').augroup
local cmp = require('cmp')

cmp.setup({
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
  },

  -- You should specify your *installed* sources.
  sources = {
    { name = 'buffer' },
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
  },
})

-- Disable on other filetypes that are not needed
augroup('cmp_user_events', {
  {
    event = 'FileType',
    pattern = 'TelescopePrompt',
    exec = function()
      cmp.setup.buffer({
        completion = {
          autocomplete = false,
        }
      })
    end,
  },
})
