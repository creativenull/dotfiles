vim9script

def TabCompletion(defaultKey: string): string
  if pumvisible()
    if exists('g:did_coc_loaded')
      return coc#_select_confirm()
    else
      return "\<C-y>"
    endif
  endif

  return defaultKey
enddef

export def Setup(): void
  nmap <Leader>ld <Plug>(coc-definition)
  nmap <Leader>lf <Plug>(coc-format)
  nmap <Leader>lr <Plug>(coc-rename)
  nmap <Leader>lh <Cmd>call CocActionAsync('doHover')<CR>
  nmap <Leader>la <Plug>(coc-codeaction-cursor)
  vmap <Leader>la <Plug>(coc-codeaction-selected)
  nmap <Leader>lw <Cmd>call CocActionAsync('diagnosticPreview')<CR>
  nmap <Leader>le <Cmd>call CocActionAsync('diagnosticList')<CR>

  inoremap <expr> <C-@> coc#refresh()

  # Insert item from menu when pressing <Tab>, like vscode
  inoremap <silent> <expr> <Tab> <SID>TabCompletion("\<Tab>")

  # Insert item from menu when pressing <CR>, like vscode
  inoremap <silent> <expr> <CR> <SID>TabCompletion("\<CR>")
enddef
