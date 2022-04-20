local telescope = require('telescope')
local telescope_builtin = require('telescope.builtin')

telescope.setup({
  defaults = {
    layout_config = { prompt_position = 'top' },
    layout_strategy = 'horizontal',
    sorting_strategy = 'ascending',
    use_less = false,
  },
})

local function find_files()
  telescope_builtin.find_files({
    find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
    previewer = false,
  })
end

local function live_grep()
  telescope_builtin.live_grep({})
end

local function find_config_files()
  local configdir
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

vim.keymap.set('n', '<C-p>', find_files, { desc = "Show Files with Telescope" })
vim.keymap.set('n', '<C-t>', live_grep, { desc = "Grep code with Telescope" })
vim.keymap.set('n', '<Leader>vf', find_config_files, { desc = "Find files in the config directory with Telescope" })
