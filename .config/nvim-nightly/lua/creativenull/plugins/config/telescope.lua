local telescope = require 'telescope'
local telescope_builtin = require 'telescope.builtin'
local telescope_actions = require 'telescope.actions'
local M = {}

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

function M.find_files()
    local config_dir = os.getenv('HOME') .. '/.config/nvim-nightly'
    telescope_builtin.find_files {
        find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden', '.', config_dir },
        previewer = false
    }
end

function M.live_grep()
    telescope_builtin.live_grep {}
end

return M
