local cmp = require('cmp')

cmp.setup({
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  },

  -- You should specify your *installed* sources.
  sources = {
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
  },

  formatting = {
    format = function(entry, item)
      item.menu = ({
        nvim_lsp = '[lsp]',
        ultisnips = '[ultisnips]',
      })[entry.source.name]

      return item
    end,
  },
})
