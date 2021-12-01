-- See :help ddc-options
-- Global config
vim.call('ddc#custom#patch_global', {
  sources = { 'nvim-lsp', 'vsnip', 'around', 'buffer' },
  sourceOptions = {
    ['_'] = {
      matchers = { 'matcher_fuzzy' },
      sorters = { 'sorter_fuzzy' },
      converters = { 'converter_fuzzy' },
    },
    ['nvim-lsp'] = {
      mark = 'LSP',
      forceCompletionPattern = '\\.|:|->',
      maxCandidates = 15,
    },
    vsnip = {
      mark = 'VSNIP',
      maxCandidates = 5,
    },
    around = {
      mark = 'AROUND',
      maxCandidates = 5,
    },
    buffer = {
      mark = 'BUFFER',
      maxCandidates = 5,
    },
  },
})

-- Different source for markdown filetype
vim.call('ddc#custom#patch_filetype', 'markdown', { sources = { 'around', 'buffer' } })

-- Enable on startup
vim.call('popup_preview#enable')
vim.call('ddc#enable')
