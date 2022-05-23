function! cnull#ddc#Setup() abort
  let s:usePumVim = get(g:, 'enable_custom_pum', 0)

  let s:sources = ['nvim-lsp', 'vsnip', 'around', 'buffer']

  let s:completionMenu = 'native'
  if s:usePumVim
    let s:completionMenu = 'pum.vim'
  endif

  let s:sourceOptions = {}
  let s:sourceOptions['_'] = #{
    \ matchers: ['matcher_fuzzy'],
    \ sorters: ['sorter_fuzzy'],
    \ converters: ['converter_fuzzy'],
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
    \ autoCompleteDelay: 100,
    \ completionMenu: s:completionMenu,
    \ sources: s:sources,
    \ sourceOptions: s:sourceOptions,
    \ sourceParams: s:sourceParams,
  \ })

  " Markdown FileType completion sources
  call ddc#custom#patch_filetype('markdown', #{ sources: ['around', 'buffer'] })

  if !s:usePumVim
    inoremap <expr> <C-y> cnull#ddc#confirm_completion("\<C-y>")
    inoremap <expr> <C-Space> ddc#map#manual_complete()
  endif

  augroup ddc_user_events
    autocmd!
    autocmd VimEnter *  call popup_preview#enable() | call signature_help#enable() | call ddc#enable()
  augroup END
endfunction

" Accept completion from ddc.vim or from vsnip
function! cnull#ddc#confirm_completion(default_key) abort
  if ddc#map#pum_visible()
    if vsnip#expandable()
      return "\<Plug>(vsnip-expand)"
    elseif ddc#map#can_complete()
      return ddc#map#extend()
    endif
  endif

  return a:default_key
endfunction
