vim9script

export def Setup(): void
  const sources = ['vim-lsp', 'around', 'buffer']
  const sourceOptions = {
    '_': {
      matchers: ['matcher_fuzzy'],
      sorters: ['sorter_fuzzy'],
      converter_fuzzy: ['converter_fuzzy'],
    },

    lsp: {
      mark: 'LS',
      maxCandidates: 10,
    },

    around: {
      mark: 'A',
      maxCandidates: 3,
    },

    buffer: {
      mark: 'A',
      maxCandidates: 3,
    },
  }

  # Register global options
  ddc#custom#patch_global({
    sources: sources,
    sourceOptions: sourceOptions,
  })

  # Filetype options
  ddc#custom#patch_filetype('markdown', { sources: ['around'] })

  # Manual trigger
  inoremap <expr> <C-@> ddc#map#manual_complete()

  augroup ddc_user_events
    autocmd!
    autocmd VimEnter * call ddc#enable()
  augroup END
enddef
