local M = {}

function M.setup()
  local cmp = require('cmp')

  cmp.setup({
    snippet = function(args)
      vim.fn['UltiSnips#Anon'](args.body)
    end,

    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },

    mapping = cmp.mapping.preset.insert({
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),

    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'ultisnips' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
      { name = 'path' },
    }),
  })
end

return M
