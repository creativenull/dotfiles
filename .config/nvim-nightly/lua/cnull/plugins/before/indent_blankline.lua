local augroup = require 'cnull.core.event'.augroup

local function indent_blankline_highlights()
  local bg     = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('Normal')), 'bg')
  local first  = '#BE185D'
  local second = '#1D4ED8'
  local third  = '#047857'
  local fourth = '#B91C1C'

  if _G.CNull.config.theme.transparent then
    bg = 'NONE'
  end

  if bg == '' then
    bg = 'NONE'
  end

  vim.cmd(string.format([[highlight IndentBlanklineFirstLine guifg=%s guibg=%s]], first, bg))
  vim.cmd(string.format([[highlight IndentBlanklineSecondLine guifg=%s guibg=%s]], second, bg))
  vim.cmd(string.format([[highlight IndentBlanklineThirdLine guifg=%s guibg=%s]], third, bg))
  vim.cmd(string.format([[highlight IndentBlanklineFourthLine guifg=%s guibg=%s]], fourth, bg))
end

augroup('user_indent_blankline_events', {
  { event = 'ColorScheme', exec = indent_blankline_highlights },
})

vim.g.indent_blankline_char = '│'
vim.g.indent_blankline_filetype_exclude = { 'help', 'markdown' }
vim.g.indent_blankline_show_first_indent_level = false
vim.g.indent_blankline_char_highlight_list = {
  'IndentBlanklineFirstLine',
  'IndentBlanklineSecondLine',
  'IndentBlanklineThirdLine',
  'IndentBlanklineFourthLine',
}
