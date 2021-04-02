local telescope = require 'telescope'
local telescope_builtin = require 'telescope.builtin'
local telescope_actions = require 'telescope.actions'
local M = {}

telescope.setup {
  defaults = {
    prompt_position = 'top',
    layout_strategy = 'horizontal',
    sorting_strategy = 'ascending',
    use_less = false
  }
}

M.find_files = function()
  telescope_builtin.find_files {
    find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
    previewer = false
  }
end

M.find_config_files = function()
  local config_dir = os.getenv('HOME') .. '/.config/nvim-nightly'
  telescope_builtin.find_files {
    find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden', config_dir },
    previewer = false
  }
end

M.live_grep = function()
  telescope_builtin.live_grep {}
end

return M
