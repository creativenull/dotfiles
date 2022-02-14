function! cnull#ddc#Setup() abort
  call ddc#custom#patch_global('completionMenu', g:enable_custom_pum ? 'pum.vim' : 'native')
  call ddc#custom#patch_global('sources', ['nvim-lsp', 'vsnip', 'around', 'buffer', 'file'])
  call ddc#custom#patch_global('sourceParams', {
    \ '_': {
      \ 'matchers': ['matcher_fuzzy'],
      \ 'sorters': ['sorter_fuzzy'],
      \ 'converters': ['converter_fuzzy'],
    \ },
    \ 'nvim-lsp': {
      \ 'mark': 'LSP',
      \ 'forceCompletionPattern': '\.\w*|:\w*|->\w*',
      \ 'maxCandidates': 10,
    \ },
    \ 'vsnip': {
      \ 'mark': 'SNIPPET',
      \ 'maxCandidates': 10,
    \ },
    \ 'around': {
      \ 'mark': 'AROUND',
      \ 'maxCandidates': 5,
    \ },
    \ 'buffer': {
      \ 'mark': 'BUFFER',
      \ 'maxCandidates': 5,
    \ },
    \ 'file': {
      \ 'mark': 'FILE',
      \ 'isVolatile': v:true,
      \ 'forceCompletionPattern': '\S/\S*',
    \ },
  \ })

  " LSP kind labels - from lspkind-nvim
  call ddc#custom#patch_global('sourceParams', {
    \ 'nvim-lsp': {
      \ 'kindLabels': {
        \ 'Class': 'ﴯ Class',
        \ 'Color': ' Color',
        \ 'Constant': ' Cons',
        \ 'Constructor': ' New',
        \ 'Enum': ' Enum',
        \ 'EnumMember': ' Enum',
        \ 'Event': ' Event',
        \ 'Field': 'ﰠ Field',
        \ 'File': ' File',
        \ 'Folder': ' Dir',
        \ 'Function': ' Fun',
        \ 'Interface': ' Int',
        \ 'Keyword': ' Key',
        \ 'Method': ' Met',
        \ 'Module': ' Mod',
        \ 'Operator': ' Op',
        \ 'Property': 'ﰠ Prop',
        \ 'Reference': ' Ref',
        \ 'Snippet': ' Snip',
        \ 'Struct': 'פּ Struct',
        \ 'Text': ' Text',
        \ 'TypeParameter': '',
        \ 'Unit': '塞 Unit',
        \ 'Value': ' Value',
        \ 'Variable': ' Var',
      \ },
    \ },
  \ })

  " Markdown FileType completion sources
  call ddc#custom#patch_filetype('markdown', { 'sources': ['around', 'buffer'] })

  " Use tab to complete the popup menu item w/ vsnip integration
  inoremap <expr> <C-y> pumvisible() ? (vsnip#expandable() ? "\<Plug>(vsnip-expand)" : "\<C-y>") : "\<C-y>"

  inoremap <expr> <C-Space> ddc#map#manual_complete()

  augroup ddc_user_events
    autocmd!
    autocmd VimEnter * call popup_preview#enable() | call ddc#enable()
  augroup END
endfunction
