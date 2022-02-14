function! cnull#lightline#Setup() abort
  let g:lightline = {}
  let g:lightline.colorscheme = 'tailwind_cnull'

  let g:lightline.enable = {}
  let g:lightline.enable.statusline = 1
  let g:lightline.enable.tabline = 1

  let g:lightline.tabline = {}
  let g:lightline.tabline.left = [ ['buffers'] ]
  let g:lightline.tabline.right = [ ['filetype'] ]

  let g:lightline.component = { 'lineinfo': ' %l/%L  %c' }

  let g:lightline.separator = {}
  let g:lightline.separator.left = ''
  let g:lightline.separator.right = ''

  let g:lightline.active = {}
  let g:lightline.active.left = [ ['filename'], ['gitbranch', 'readonly', 'modified'] ]
  let g:lightline.active.right = [ ['ale_err', 'ale_warn', 'ale_status'], ['filetype', 'fileencoding'], ['lineinfo'] ]

  let g:lightline.inactive = {}
  let g:lightline.inactive.left = [ ['filename'], ['gitbranch', 'modified'] ]
  let g:lightline.inactive.right = [ [], [], ['lineinfo'] ]

  let g:lightline.component_function = {}
  let g:lightline.component_function.gitbranch = 'FugitiveHead'
  let g:lightline.component_function.ale_status = 'cnull#ale#StlStatus'

  let g:lightline.component_expand = {}
  let g:lightline.component_expand.ale_err = 'cnull#ale#StlErrComponent'
  let g:lightline.component_expand.ale_warn = 'cnull#ale#StlWarnComponent'
  let g:lightline.component_expand.buffers = 'lightline#bufferline#buffers'

  let g:lightline.component_type = {}
  let g:lightline.component_type.ale_err = 'error'
  let g:lightline.component_type.ale_warn = 'warning'
  let g:lightline.component_type.buffers = 'tabsel'

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
