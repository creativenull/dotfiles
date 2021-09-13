local ddc = {
  patch_global = vim.fn['ddc#custom#patch_global'],
  nvim_lsp_doc = { enable = vim.fn['ddc_nvim_lsp_doc#enable'] },
}

ddc.patch_global('autoCompleteDelay', 250)
ddc.patch_global('sources', {'nvimlsp', 'ultisnips', 'around'})
ddc.patch_global('sourceOptions', {
  ['_'] = {
    matchers = {'matcher_fuzzy'},
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
vim.api.nvim_set_keymap('n', '<C-Space>', 'ddc#manual_complete()', { silent = true, noremap = true, expr = true })
