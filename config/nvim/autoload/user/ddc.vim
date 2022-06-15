function! user#ddc#Setup() abort
  let s:sources = ['nvim-lsp', 'vsnip', 'around', 'buffer']

  let s:sourceOptions = {}
  let s:sourceOptions['_'] = #{
    \ matchers: ['matcher_fuzzy'],
    \ sorters: ['sorter_fuzzy'],
    \ converters: ['converter_fuzzy'],
  \ }

  let s:sourceOptions['nvim-lsp'] = #{
    \ mark: 'Language',
    \ forceCompletionPattern: '\.\w*|:\w*|->\w*',
    \ maxCandidates: 10,
  \ }

  let s:sourceOptions.vsnip = #{
    \ mark: 'Snippet',
    \ maxCandidates: 5,
  \ }

  let s:sourceOptions.around = #{
    \ mark: 'Local',
    \ maxCandidates: 3,
  \ }

  let s:sourceOptions.buffer = #{
    \ mark: 'Buffer',
    \ maxCandidates: 3,
  \ }

  let s:sourceParams = {}
  let s:sourceParams['nvim-lsp'] = #{
    \ kindLabels: #{
      \ Class: 'ﴯ Class',
      \ Color: ' Color',
      \ Constant: ' Constant',
      \ Constructor: ' New',
      \ Enum: ' Enum',
      \ EnumMember: ' Enum',
      \ Event: ' Event',
      \ Field: 'ﰠ Field',
      \ File: ' File',
      \ Folder: ' Directory',
      \ Function: ' Function',
      \ Interface: ' Interface',
      \ Keyword: ' Key',
      \ Method: ' Method',
      \ Module: ' Module',
      \ Operator: ' Operator',
      \ Property: 'ﰠ Property',
      \ Reference: ' Reference',
      \ Snippet: ' Snippet',
      \ Struct: 'פּ Struct',
      \ Text: ' Text',
      \ TypeParameter: '',
      \ Unit: '塞 Unit',
      \ Value: ' Value',
      \ Variable: ' Variable',
    \ },
  \ }

  call ddc#custom#patch_global(#{
    \ autoCompleteDelay: 100,
    \ overwriteCompleteopt: v:false,
    \ backspaceCompletion: v:true,
    \ smartCase: v:true,
    \ sources: s:sources,
    \ sourceOptions: s:sourceOptions,
    \ sourceParams: s:sourceParams,
  \ })

  " Markdown FileType completion sources
  call ddc#custom#patch_filetype('markdown', #{ sources: ['around', 'buffer'] })

  inoremap <expr> <C-y> user#ddc#confirm_completion("\<C-y>")
  inoremap <expr> <C-Space> ddc#map#manual_complete()

  augroup ddc_user_events
    autocmd!
    autocmd VimEnter *  call user#ddc#Enable()
  augroup END
endfunction

function! user#ddc#Enable() abort
  call ddc#enable()
  call signature_help#enable()
endfunction

" Accept completion from ddc.vim or from vsnip
function! user#ddc#confirm_completion(default_key) abort
  if ddc#map#pum_visible()
    if vsnip#expandable()
      return "\<Plug>(vsnip-expand)"
    elseif ddc#map#can_complete()
      return ddc#map#extend()
    endif
  endif

  return a:default_key
endfunction
