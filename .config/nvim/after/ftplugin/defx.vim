function! s:defx_maps() abort
  nnoremap <silent><buffer><expr> <CR> defx#do_action('open')
  nnoremap <silent><buffer><expr> yy defx#do_action('copy')
  nnoremap <silent><buffer><expr> x defx#do_action('move')
  nnoremap <silent><buffer><expr> p defx#do_action('paste')
  nnoremap <silent><buffer><expr> l defx#do_action('open')
  nnoremap <silent><buffer><expr> e defx#do_action('open', 'vsplit')
  " nnoremap <silent><buffer><expr> p defx#do_action('preview')
  " nnoremap <silent><buffer><expr> o defx#do_action('open_tree', 'toggle')
  nnoremap <silent><buffer><expr> nd defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> nf defx#do_action('new_file')
  " nnoremap <silent><buffer><expr> m defx#do_action('new_multiple_files')
  " nnoremap <silent><buffer><expr> c defx#do_action('toggle_columns', 'mark:indent:icon:filename:type:size:time')
  " nnoremap <silent><buffer><expr> s defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> dd defx#do_action('remove')
  nnoremap <silent><buffer><expr> r defx#do_action('rename')
  " nnoremap <silent><buffer><expr> ! defx#do_action('execute_command')
  " nnoremap <silent><buffer><expr> x defx#do_action('execute_system')
  " nnoremap <silent><buffer><expr> yy defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> . defx#do_action('toggle_ignored_files')
  " nnoremap <silent><buffer><expr> ; defx#do_action('repeat')
  nnoremap <silent><buffer><expr> h defx#do_action('cd', ['..'])
  " nnoremap <silent><buffer><expr> ~ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q defx#do_action('quit')
  nnoremap <silent><buffer><expr> <space> defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> * defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k line('.') == 1 ? 'g' : 'k'
  " nnoremap <silent><buffer><expr> <c-l> defx#do_action('redraw')
  " nnoremap <silent><buffer><expr> <c-g> defx#do_action('print')
  " nnoremap <silent><buffer><expr> cd defx#do_action('change_vim_cwd')
endfunction

call s:defx_maps()
