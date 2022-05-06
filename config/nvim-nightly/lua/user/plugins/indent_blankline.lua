local loaded = false

local function setup()
  require('indent_blankline').setup({
    char = '│',
    buftype_exclude = { 'help', 'markdown' },
    char_highlight_list = { 'IndentBlanklineHighlight' },
    show_first_indent_level = false,
  })
end

local lazy_load_indent_blankline = vim.api.nvim_create_augroup(
  'lazy_load_indent_blankline_user_events',
  { clear = true }
)

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufRead', 'BufNew' }, {
  desc = 'Lazy load indent_blankline',
  group = lazy_load_indent_blankline,
  once = true,

  callback = function()
    if not loaded then
      vim.cmd('packadd indent-blankline.nvim')
      loaded = true
    end

    setup()
  end,
})

local indent_blankline_group = vim.api.nvim_create_augroup('indent_blankline_user_events', { clear = true })

if _G.User.transparent then
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = indent_blankline_group,
    command = 'highlight! IndentBlanklineHighlight guifg=#777777 guibg=NONE',
    desc = 'Change indent blankline color to be lighter in transparent mode',
  })
else
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = indent_blankline_group,
    command = 'highlight! IndentBlanklineHighlight guifg=#444444 guibg=NONE',
    desc = 'Change indent blankline color to be darker',
  })
end
