function! s:vimgrep(qargs, bang) abort
  let sh = "rg --column --line-number --no-heading --color=always --smart-case -- " . shellescape(a:qargs)
  call fzf#vim#grep(sh, 1, fzf#vim#with_preview('right:50%', 'ctrl-/'), a:bang)
endfunction

function! s:ft_setup() abort
  setlocal noruler
  autocmd BufLeave <buffer> setlocal ruler
endfunction

function! cnull#fzf#Setup() abort
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob !.git'
  let $FZF_DEFAULT_OPTS = '--reverse'
  let g:fzf_preview_window = []

  nnoremap <C-p> <Cmd>Files<CR>
  nnoremap <C-t> <Cmd>Rg<CR>

  command! -bang -nargs=* Rg call s:vimgrep(<q-args>, <bang>0)

  augroup fzf_user_events
    autocmd!
    autocmd FileType fzf call s:ft_setup()
    autocmd ColorScheme * highlight fzfBorder guifg=#aaaaaa
  augroup END
endfunction
