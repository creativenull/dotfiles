vim9script

export def Setup(): void
  $FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob !.git'
  $FZF_DEFAULT_OPTS = '--reverse'
  g:fzf_preview_window = []

  nnoremap <C-p> <Cmd>Files<CR>
  nnoremap <C-t> <Cmd>Rg<CR>

  # Custom UI interface for greping code with fzf
  command! -bang -nargs=* Rg call user#fzf#VimGrep(<q-args>, <bang>0)

  augroup fzf_highlight_user_events
    autocmd!
    # Use a lighter border color
    autocmd ColorScheme * highlight! fzfBorder guifg=#aaaaaa
  augroup END
enddef

export def VimGrep(qargs: string, bang: any): void
  const sh = 'rg --column --line-number --no-heading --color=always --smart-case -- ' .. shellescape(qargs)

  fzf#vim#grep(sh, 1, fzf#vim#with_preview('right:50%', 'ctrl-/'), bang)
enddef
