-- See :help ddc-options
local ddc = {
  custom = {
    patch_global = vim.fn['ddc#custom#patch_global'],
  },
}

ddc.custom.patch_global({
  autoCompleteDelay = 100,
  backspaceCompletion = true,
  completionMenu = 'pum.vim',
  sources = {'nvim-lsp', 'vsnip', 'around', 'buffer'},
  sourceOptions = {
    ['_'] = {
      matchers = {'matcher_fuzzy'},
      sorters = {'sorter_fuzzy'},
      converters = {'sorter_fuzzy'},
    },
    ['vsnip'] = {
      mark = 'VSNIP',
    },
    ['nvim-lsp'] = {
      mark = 'LSP',
      forceCompletionPattern = '\\.|:|->',
    },
    ['around'] = {
      mark = 'AROUND',
    },
    ['buffer'] = {
      mark = 'BUFFER',
    },
  },
})

--[[ local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },

  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },

  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  },

  formatting = {
    format = function(entry, item)
      item.menu = ({
        nvim_lsp = '[LSP]',
        vsnip = '[VSNIP]',
      })[entry.source.name]

      return item
    end,
  },
}) ]]
