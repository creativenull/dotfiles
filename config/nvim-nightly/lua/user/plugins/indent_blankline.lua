local loaded = false

local function setup()
  require('indent_blankline').setup({
    char = '│',
    buftype_exclude = { 'help', 'markdown' },
    char_highlight_list = { 'IndentBlanklineHighlight' },
    show_first_indent_level = false,
  })
end

local lazyLoadIndentBlanklinePluginGroup = vim.api.nvim_create_augroup(
  'lazyLoadIndentBlanklinePluginGroup',
  { clear = true }
)

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufRead', 'BufNew' }, {
  desc = 'Lazy load indent_blankline',
  group = lazyLoadIndentBlanklinePluginGroup,
  once = true,

  callback = function()
    if not loaded then
      vim.cmd('packadd indent-blankline.nvim')
      loaded = true
    end

    setup()
  end,
})

local indentBlanklineUserGroup = vim.api.nvim_create_augroup('indentBlanklineUserGroup', { clear = true })

if _G.User.transparent then
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = indentBlanklineUserGroup,
    command = 'highlight! IndentBlanklineHighlight guifg=#777777 guibg=NONE',
    desc = 'Change indent blankline color to be lighter in transparent mode',
  })
else
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = indentBlanklineUserGroup,
    command = 'highlight! IndentBlanklineHighlight guifg=#444444 guibg=NONE',
    desc = 'Change indent blankline color to be darker',
  })
end
