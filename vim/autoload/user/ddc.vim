vim9script

export def Setup(): void
  const sources = ['vim-lsp', 'vsnip', 'around']
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

    vsnip: {
      mark: 'S',
      maxCandidates: 5,
    },

    around: {
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

  # Complete vsnip snippet if it's possible
  inoremap <expr> <C-y> pumvisible() ? (vsnip#expandable() ? "\<Plug>(vsnip-expand)" : "\<C-y>") : "\<C-y>"
  inoremap <expr> <Tab> pumvisible() ? (vsnip#expandable() ? "\<Plug>(vsnip-expand)" : "\<C-y>") : "\<Tab>"

  # Manual trigger
  inoremap <expr> <C-@> ddc#map#manual_complete()

  augroup ddc_user_events
    au!
    autocmd VimEnter * call popup_preview#enable() | call ddc#enable()
  augroup END
enddef
