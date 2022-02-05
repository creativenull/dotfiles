function! cnull#lightline#setup() abort
  let g:lightline = {}
  let g:lightline.colorscheme = 'moonfly'
  let g:lightline.component = { 'lineinfo': '%l/%L:%c' }

  let g:lightline.separator = {
    \ 'left':  '',
    \ 'right': '',
  \ }

  let g:lightline.active = {
    \ 'left': [
      \ ['filename'],
      \ ['gitbranch', 'readonly', 'modified'],
    \ ],
    \ 'right': [
      \ ['ale_err', 'ale_warn', 'ale_status'],
      \ ['lineinfo'],
      \ ['filetype', 'fileencoding'],
    \ ],
  \ }

  let g:lightline.component_function = {
    \ 'gitbranch': 'FugitiveHead',
    \ 'ale_status': 'cnull#ale#stl_status',
  \ }

  let g:lightline.component_expand = {
    \ 'ale_err': 'cnull#ale#stl_err_component',
    \ 'ale_warn': 'cnull#ale#stl_warn_component',
  \ }

  let g:lightline.component_type = {
    \ 'ale_error_component': 'error',
    \ 'ale_warning_component': 'warning',
  \ }
endfunction
