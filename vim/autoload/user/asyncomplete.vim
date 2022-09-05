vim9script

export def Setup(): void
  g:asyncomplete_popup_delay = 150
  g:asyncomplete_min_chars = 2
  g:asyncomplete_matchfuzzy = 1

  imap <C-@> <Plug>(asyncomplete_force_refresh)
  inoremap <expr> <Tab> pumvisible() ? asyncomplete#close_popup() : "\<Tab>"
  inoremap <expr> <CR>  pumvisible() ? asyncomplete#close_popup() : "\<CR>"

  asyncomplete#register_source(
    asyncomplete#sources#buffer#get_source_options({
      name: 'buffer',
      allowlist: ['*'],
      blocklist: ['go'],
      completor: function('asyncomplete#sources#buffer#completor'),
      config: {
        max_buffer_size: 500 * 1000, # 500KB
      },
    })
  )
enddef
