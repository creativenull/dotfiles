local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },

  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
    ['<Tab>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
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

--[[ local ddc = {
  patch_global = vim.fn['ddc#custom#patch_global'],
  nvim_lsp_doc = {
    enable = vim.fn['ddc_nvim_lsp_doc#enable'],
  },
}

ddc.patch_global('autoCompleteDelay', 250)
ddc.patch_global('sources', {'nvimlsp', 'ultisnips', 'around'})
ddc.patch_global('sourceOptions', {
  ['_'] = {
    matchers = {'matcher_full_fuzzy'},
    sorters = {'sorter_rank'},
    ignoreCase = true,
  },
  ultisnips = {
    mark = 'ultisnips',
  },
  nvimlsp = {
    mark = 'lsp',
    forceCompletionPattern = '\\.|:|->',
  },
  around = {
    mark = 'around',
  },
})

ddc.nvim_lsp_doc.enable()

-- Tab completion
local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function _G.user_tab_completion(default_keybind)
  if vim.fn.pumvisible() == 1 then
    if vim.call('UltiSnips#CanExpandSnippet') == 1 then
      return termcodes('<C-r>=UltiSnips#ExpandSnippet()<CR>')
    else
      return termcodes('<C-y>')
    end
  end

  return termcodes(default_keybind)
end ]]
