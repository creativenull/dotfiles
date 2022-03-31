function! cnull#coc#Setup() abort
  nnoremap <silent> <Leader>ld <Cmd>call CocActionAsync('jumpDefinition')<CR>
  nnoremap <silent> <Leader>lf <Cmd>call CocActionAsync('format')<CR>
  nnoremap <silent> <Leader>lr <Cmd>call CocActionAsync('rename')<CR>
  nnoremap <silent> <Leader>lh <Cmd>call CocActionAsync('doHover')<CR>
  nnoremap <silent> <Leader>la <Cmd>call CocActionAsync('codeAction')<CR>
  nnoremap <silent> <Leader>le <Cmd>CocList diagnostics<CR>
  inoremap <silent> <expr> <C-@> coc#refresh()

  " Insert item from menu when pressing <Tab>, like vscode
  inoremap <silent> <expr> <Tab> pumvisible()
    \ ? exists('g:did_coc_loaded')
      \ ? coc#_select_confirm()
      \ : "\<C-y>"
    \ : "\<Tab>"

  " Insert item from menu when pressing <CR>, like vscode
  inoremap <silent> <expr> <CR> pumvisible()
    \ ? exists('g:did_coc_loaded')
      \ ? coc#_select_confirm()
      \ : "\<C-y>"
    \ : "\<CR>"
endfunction
