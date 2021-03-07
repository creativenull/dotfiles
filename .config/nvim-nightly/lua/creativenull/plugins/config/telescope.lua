local telescope = require 'telescope'
local telescope_builtin = require 'telescope.builtin'
local telescope_actions = require 'telescope.actions'
local M = {}

M.config = function()
  telescope.setup {
    defaults = {
      layout_strategy = 'vertical',
      use_less = false,
      mappings = {
        i = {
          ['<C-k>'] = telescope_actions.move_selection_previous,
          ['<C-j>'] = telescope_actions.move_selection_next
        }
      }
    }
  }
end

M.find_project_files = function()
  telescope_builtin.find_files {
    find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
    previewer = false
  }
end

M.find_vim_config_files = function()
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
