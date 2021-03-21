-- Yank highlight
vim.api.nvim_exec([[
  augroup yank_hl
  au!
  au TextYankPost * silent! lua vim.highlight.on_yank({ higroup = "Search", timeout = 500 })
  augroup end
]], false)

-- Statusline/Tabline highlights
vim.api.nvim_exec([[
  augroup statusline_tabline_hl
  au!
  au ColorScheme * lua require 'creativenull.statusline'.set_highlights()
  au ColorScheme * lua require 'creativenull.tabline'.set_highlights()
  augroup end
]], false)

-- Statusline
vim.api.nvim_exec([[
  augroup statusline_local
  au!
  au WinEnter * lua require 'creativenull.statusline'.setlocal_active_statusline()
  au WinLeave * lua require 'creativenull.statusline'.setlocal_inactive_statusline()
  augroup end
]], false)

 -- Enable invisible chars
vim.api.nvim_exec([[
  augroup disable_char_list
  au!
  au FileType help setlocal nolist
  au FileType TelescopePrompt setlocal nolist
  augroup end
]], false)

-- lua 2 space indent
vim.cmd 'au! FileType lua setlocal tabstop=2'
