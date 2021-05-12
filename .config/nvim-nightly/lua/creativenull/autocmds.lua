local set_augroup = require 'creativenull.utils'.set_augroup

-- Yank highlight
set_augroup('yank_hl', {
  [[au TextYankPost * silent! lua vim.highlight.on_yank({ higroup = 'Search', timeout = 500 })]]
})

-- Set Transparent Backgrounds
set_augroup('transparent_bg', {
  'au ColorScheme * hi! Normal guibg=NONE',
  'au ColorScheme * hi! SignColumn guibg=NONE',
  'au ColorScheme * hi! LineNr guibg=NONE',
  'au ColorScheme * hi! CursorLineNr guibg=NONE',
})

 -- Hide invisible chars in help and telescope
set_augroup('nolist_by_ft', {
  'au FileType help setlocal nolist',
  'au FileType TelescopePrompt setlocal nolist'
})

-- Exit file explorer
set_augroup('netrw_exit', {
  'au FileType netrw nnoremap <buffer> <Esc> <cmd>Rex<CR>'
})

-- lua 2 space indent
set_augroup('lua_indent', {
  'au FileType lua setlocal tabstop=2'
})

-- nvim biscuits
set_augroup('biscuits_hl', {
  'au ColorScheme * hi BiscuitColor guifg=#444444 gui=italic'
})
