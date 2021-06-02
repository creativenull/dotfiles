local set_augroup = require 'creativenull.utils'.set_augroup

-- Trim whitespace on all file
set_augroup('trim_whitespace', { [[au BufWritePre * %s/\s\+$//e]] })

-- Yank highlight
set_augroup('yank_hl', {
  [[au TextYankPost * silent! lua vim.highlight.on_yank({ higroup = 'Search', timeout = 500 })]]
})

-- Set Transparent Backgrounds
set_augroup('transparent_bg', {
  'au ColorScheme * hi! Normal guibg=NONE',
  'au ColorScheme * hi! SignColumn guibg=NONE',
  'au ColorScheme * hi! LineNr guibg=NONE guifg=#aaaaaa',
  'au ColorScheme * hi! CursorLineNr guibg=NONE',
})

-- Hide invisible chars in help and telescope
set_augroup('nolist_by_ft', {
  'au FileType help setlocal nolist',
  'au FileType TelescopePrompt setlocal nolist'
})

-- nvim biscuits
set_augroup('biscuits_hl', {
  'au ColorScheme * hi BiscuitColor guifg=#999999 gui=italic'
})
