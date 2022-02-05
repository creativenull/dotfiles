function! cnull#fzf#vim_grep(qargs, bang) abort
  let sh = 'rg --column --line-number --no-heading --color=always --smart-case -- ' . shellescape(a:qargs)
  fzf#vim#grep(sh, 1, fzf#vim#with_preview('right:50%', 'ctrl-/'), a:bang)
endfunction
