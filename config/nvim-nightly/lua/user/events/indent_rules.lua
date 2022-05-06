-- Default Filetype Options
local function indent_size(size, use_spaces)
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].tabstop = size
  vim.bo[buf].softtabstop = size
  vim.bo[buf].shiftwidth = size

  if use_spaces then
    vim.bo[buf].expandtab = true
  else
    vim.bo[buf].expandtab = false
  end
end

local filetype = vim.api.nvim_create_augroup('filetype_user_events', { clear = true })

-- Use 4 space indents for the following filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = filetype,

  pattern = { 'php', 'blade', 'html' },

  callback = function()
    indent_size(4, true)
  end,

  desc = 'Indent 4 spaces',
})

-- Use 2 space indents for the following filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = filetype,

  pattern = {
    'vim',
    'lua',
    'scss',
    'sass',
    'css',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'json',
    'jsonc',
    'vue',
  },

  callback = function()
    indent_size(2, true)
  end,

  desc = 'Indent 2 spaces',
})

-- Enable spell check, 2 space indents in markdown files
vim.api.nvim_create_autocmd('FileType', {
  group = filetype,

  pattern = 'markdown',

  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.bo[bufnr].spell = true

    indent_size(2, true)
  end,

  desc = 'Indent 2 spaces and enable spell check',
})
