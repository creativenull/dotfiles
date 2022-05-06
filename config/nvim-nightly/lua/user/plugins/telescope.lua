if _G.User.transparent then
  local telescopePluginUserGroup = vim.api.nvim_create_augroup('telescopePluginUserGroup', { clear = true })

  vim.api.nvim_create_autocmd('ColorScheme', {
    group = telescopePluginUserGroup,
    command = 'highlight! TelescopeBorder guifg=#aaaaaa',
  })
end

local function setup()
  local telescope = require('telescope')

  telescope.setup({
    defaults = {
      layout_config = { prompt_position = 'top' },
      layout_strategy = 'horizontal',
      sorting_strategy = 'ascending',
      use_less = false,
    },
  })
end

local function find_files()
  local telescope_builtin = require('telescope.builtin')

  telescope_builtin.find_files({
    find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
    previewer = false,
  })
end

local function live_grep()
  local telescope_builtin = require('telescope.builtin')

  telescope_builtin.live_grep({})
end

local function find_config_files()
  local telescope_builtin = require('telescope.builtin')
  local configdir = ''

  if vim.g.userspace ~= nil then
    configdir = vim.fn.expand('$HOME/.config/' .. vim.g.userspace)
  else
    configdir = vim.fn.stdpath('config')
  end

  telescope_builtin.find_files({
    find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden', configdir },
    previewer = false,
  })
end

-- Lazy loading with command
local loaded = false
local function packload()
  if not loaded then
    vim.cmd('packadd telescope.nvim')
    setup()
  end
end

vim.api.nvim_create_user_command('UserTelescopeFindFiles', function()
  packload()
  find_files()
end, { desc = 'Open fuzzy finder with telescope' })

vim.api.nvim_create_user_command('UserTelescopeLiveGrep', function()
  packload()
  live_grep()
end, { desc = 'Grep code with telescop' })

vim.api.nvim_create_user_command('UserTelescopeFindConfigFiles', function()
  packload()
  find_config_files()
end, { desc = 'Open fuzzy finder in config dir with telescope' })

vim.keymap.set('n', '<C-p>', '<Cmd>UserTelescopeFindFiles<CR>')
vim.keymap.set('n', '<C-t>', '<Cmd>UserTelescopeLiveGrep<CR>')
vim.keymap.set('n', '<Leader>vf', '<Cmd>UserTelescopeFindConfigFiles<CR>')
