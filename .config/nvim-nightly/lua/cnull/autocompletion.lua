-- See :help ddc-options
local ddc_patch_global = vim.fn['ddc#custom#patch_global']

ddc_patch_global({
  autoCompleteDelay = 100,
  backspaceCompletion = true,
  sources = {'nvim-lsp', 'ultisnips', 'around', 'buffer'},
  sourceOptions = {
    ['_'] = {
      -- matchers = {'matcher_fuzzy', 'matcher_length'},
      matchers = {'matcher_fuzzy'},
      -- sorters = {'sorter_rank'},
      sorters = {'sorter_fuzzy'},
      ignoreCase = true,
    },
    ['ultisnips'] = {
      mark = 'ultisnips',
    },
    ['nvim-lsp'] = {
      mark = 'lsp',
      forceCompletionPattern = '\\.|:|->',
    },
    ['around'] = {
      mark = 'around',
    },
    ['buffer'] = {
      mark = 'buffer',
    },
  },
})

--[[ ddc_patch_global('autoCompleteDelay', 100)
ddc_patch_global('sources', {'nvim-lsp', 'ultisnips', 'around'})
ddc_patch_global('sourceOptions', {
  ['_'] = {
    matchers = {'matcher_fuzzy', 'matcher_length'},
    sorters = {'sorter_rank'},
    ignoreCase = true,
  },
  ['ultisnips'] = {
    mark = 'ultisnips',
  },
  ['nvim-lsp'] = {
    mark = 'lsp',
    forceCompletionPattern = '\\.|:|->',
  },
  ['around'] = {
    mark = 'around',
  },
}) ]]
