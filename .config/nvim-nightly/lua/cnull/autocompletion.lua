local ddc_patch_global = vim.fn['ddc#custom#patch_global']

ddc_patch_global('autoCompleteDelay', 250)
ddc_patch_global('sources', {'nvimlsp', 'ultisnips', 'around'})
ddc_patch_global('sourceOptions', {
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
