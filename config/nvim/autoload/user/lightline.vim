function! user#lightline#Setup() abort
  let g:lightline = #{
    \ colorscheme: 'tailwind_cnull',
    \ enable: #{ statusline: 1, tabline: 1 },
    \ separator: #{ left: '', right: '' },
    \ tabline: #{ left: [ ['buffers'] ], right: [ ['filetype'] ] },
    \ active: #{
      \ left: [ ['filename'], ['gitbranch', 'readonly', 'modified'] ],
      \ right: [
        \ ['ale_err', 'ale_warn', 'ale_status', 'nvimlsp_status'],
        \ ['filetype', 'fileencoding'],
        \ ['lineinfo']
      \ ],
    \ },
    \ inactive: #{
      \ left: [ ['filename'], [] ],
      \ right: [ [], [], ['lineinfo'] ],
    \ },
    \ component: #{ lineinfo: ' %l/%L  %c' },
    \ component_function: #{
      \ gitbranch: 'user#lightline#GitBranch',
      \ ale_status: 'user#ale#StlStatus',
      \ nvimlsp_status: 'user#nvimlsp#LspStatus',
    \ },
    \ component_expand: #{
      \ ale_err: 'user#ale#StlErrComponent',
      \ ale_warn: 'user#ale#StlWarnComponent',
      \ buffers: 'lightline#bufferline#buffers',
    \ },
    \ component_type: #{
      \ ale_err: 'error',
      \ ale_warn: 'warning',
      \ buffers: 'tabsel',
    \ },
  \ }

  augroup ale_lightline_user_events
    autocmd!
    autocmd User ALEJobStarted call lightline#update()
    autocmd User ALELintPost call lightline#update()
    autocmd User ALEFixPost call lightline#update()
  augroup END

  " lightline-bufferline Config
  " ---
  let g:lightline#bufferline#enable_nerdfont = 1
endfunction

function! user#lightline#GitBranch() abort
  return printf(' %s', gitbranch#name())
endfunction
