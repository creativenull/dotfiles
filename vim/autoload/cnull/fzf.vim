function! cnull#fzf#Setup() abort
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob !.git'
  let $FZF_DEFAULT_OPTS = '--reverse'
  let g:fzf_preview_window = []

  nnoremap <C-p> <Cmd>Files<CR>
  nnoremap <C-t> <Cmd>Rg<CR>

  " Custom UI interface for greping code with fzf
  command! -bang -nargs=* Rg call cnull#fzf#VimGrep(<q-args>, <bang>0)

  augroup fzf_highlight_user_events
    autocmd!

    " Use a lighter border color
    autocmd ColorScheme * highlight! fzfBorder guifg=#aaaaaa
  augroup END
endfunction

function! cnull#fzf#VimGrep(qargs, bang) abort
  let sh = 'rg --column --line-number --no-heading --color=always --smart-case -- ' . shellescape(a:qargs)

  call fzf#vim#grep(sh, 1, fzf#vim#with_preview('right:50%', 'ctrl-/'), a:bang)
endfunction
