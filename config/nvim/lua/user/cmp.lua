local M = {}

local function register_events()
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.g.user.event,
    callback = function()
      vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'NONE' })
    end,
    desc = 'Transparent bg for completion menu',
  })
end

function M.setup()
  register_events()

  local cmp = require('cmp')

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn['UltiSnips#Anon'](args.body)
      end,
    },

    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },

    mapping = cmp.mapping.preset.insert({
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      -- ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),

    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'ultisnips' }, -- For vsnip users.
    }, {
      { name = 'nvim_lsp_signature_help' },
      { name = 'buffer' },
      { name = 'path' },
    }),
  })
end

return M
