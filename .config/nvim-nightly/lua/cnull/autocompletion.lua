--[[ require('compe').setup({
  source = {
    nvim_lsp  = true,
    ultisnips = true,
  },
}) ]]

local ddc = {
  patch_global = vim.fn['ddc#custom#patch_global'],
  nvim_lsp_doc = {
    enable = vim.fn['ddc_nvim_lsp_doc#enable'],
  },
}

ddc.patch_global('sources', {'nvimlsp', 'ultisnips', 'around', 'buffer'})
ddc.patch_global('sourceOptions', {
  ['_'] = {
    matchers = {'matcher_fuzzy'},
    sorters = {'sorter_rank'},
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
  buffer = {
    mark = 'buffer',
  },
})

ddc.nvim_lsp_doc.enable()
