local modconfig = (...)
local M = {}

local function add(modname)
  local modulepath = string.format('%s.%s', modconfig, modname)
  require(modulepath)
end

M.init = function()
  add 'emmet'

  vim.g.indent_blankline_char_list = { '▏', '▏', '▏', '▏', '▏' }
  vim.g.indent_blankline_char_highlight_list = {
    'LspDiagnosticsSignInformation',
    'LspDiagnosticsSignHint',
    'LspDiagnosticsSignWarning',
    'LspDiagnosticsSignError'
  }
  vim.g.indent_blankline_space_char = ' '
  vim.g.indent_blankline_space_char_blankline = ' '
  vim.g.indent_blankline_show_first_indent_level = false
  vim.g.indent_blankline_filetype_exclude = { 'help', 'packer', 'TelescopePrompt' }

  vim.g['nnn#layout'] = { right = '~35%' }
end

M.setup = function()
  add 'gitsigns'
  add 'lsp'
  add 'projectcmd'
  add 'compe'
  add 'telescope'
  -- add 'autopairs'
  add 'lspsaga'
  add 'galaxyline'

  -- treesitter and co
  add 'treesitter'
  -- add 'biscuits'

  vim.o.termguicolors = true
  require 'bufferline'.setup {
    options = {
      indicator_icon = '',
      close_icon = '',
      buffer_close_icon = '',
      show_buffer_close_icons = false,
      show_close_icon = false
    }
  }

  require 'todo-comments'.setup {
    signs = false
  }
end

return M
