local command = require 'cnull.core.command'

function _G.FzfVimGrep(qargs, bang)
  qargs = vim.fn.shellescape(qargs)
  local rg = 'rg --column --line-number --no-heading --color=always --smart-case -- ' .. qargs
  local grep = vim.fn['fzf#vim#grep']
  local with_preview = vim.fn['fzf#vim#with_preview']

  grep(rg, 1, with_preview('right:50%', 'ctrl-/'), bang)
end

command('Rg', [[lua FzfVimGrep(<q-args>, <bang>0)]], { '-bang', '-nargs=*' })
