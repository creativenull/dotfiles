function! cnull#ddc#Setup() abort
  let s:completionMenu = g:enable_custom_pum ? 'pum.vim' : 'native'
  let s:sources = ['nvim-lsp', 'vsnip', 'around', 'buffer']

  let s:sourceOptions = {}
  let s:sourceOptions['_'] = #{
    \ matchers: ['matcher_fuzzy'],
    \ sorters: ['sorter_fuzzy'],
    \ converters: ['converter_fuzzy']
  \ }
  let s:sourceOptions['nvim-lsp'] = #{
    \ mark: 'LS',
    \ forceCompletionPattern: '\.\w*|:\w*|->\w*',
    \ maxCandidates: 10,
  \ }
  let s:sourceOptions.vsnip = #{
    \ mark: 'S',
    \ maxCandidates: 5,
  \ }
  let s:sourceOptions.around = #{
    \ mark: 'A',
    \ maxCandidates: 3,
  \ }
  let s:sourceOptions.buffer = #{
    \ mark: 'B',
    \ maxCandidates: 3,
  \ }

  let s:sourceParams = {}
  let s:sourceParams['nvim-lsp'] = #{
    \ kindLabels: #{
      \ Class: 'ﴯ Class',
      \ Color: ' Color',
      \ Constant: ' Cons',
      \ Constructor: ' New',
      \ Enum: ' Enum',
      \ EnumMember: ' Enum',
      \ Event: ' Event',
      \ Field: 'ﰠ Field',
      \ File: ' File',
      \ Folder: ' Dir',
      \ Function: ' Fun',
      \ Interface: ' Int',
      \ Keyword: ' Key',
      \ Method: ' Method',
      \ Module: ' Mod',
      \ Operator: ' Op',
      \ Property: 'ﰠ Prop',
      \ Reference: ' Ref',
      \ Snippet: ' Snip',
      \ Struct: 'פּ Struct',
      \ Text: ' Text',
      \ TypeParameter: '',
      \ Unit: '塞 Unit',
      \ Value: ' Value',
      \ Variable: ' Var',
    \ },
  \ }

  call ddc#custom#patch_global(#{
    \ completionMenu: s:completionMenu,
    \ sources: s:sources,
    \ sourceOptions: s:sourceOptions,
    \ sourceParams: s:sourceParams,
  \ })

  " Markdown FileType completion sources
  call ddc#custom#patch_filetype('markdown', #{ sources: ['around', 'buffer'] })

  " Complete vsnip snippet if it's possible
  inoremap <expr> <C-y> pumvisible() ? (vsnip#expandable() ? "\<Plug>(vsnip-expand)" : "\<C-y>") : "\<C-y>"

  " Manual trigger
  inoremap <expr> <C-Space> ddc#map#manual_complete()

  augroup ddc_user_events
    autocmd!
    autocmd VimEnter * call popup_preview#enable() | call ddc#enable()
  augroup END
endfunction
