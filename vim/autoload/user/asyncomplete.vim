vim9script

export def Setup(): void
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
        max_buffer_size: 2000000, # 2mb
      },
    })
  )
enddef
