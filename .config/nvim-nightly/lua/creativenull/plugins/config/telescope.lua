local utils = require 'creativenull.utils'
local telescope = require 'telescope'
local telescope_actions = require 'telescope.actions'

telescope.setup {
    defaults = {
        mappings = {
            i = {
                ['<C-k>'] = telescope_actions.move_selection_previous,
                ['<C-j>'] = telescope_actions.move_selection_next
            }
        }
    }
}

utils.nnoremap('<C-p>', '<cmd>Telescope find_files find_command=rg,--files,--hidden,--iglob,!.git<CR>')
utils.nnoremap('<C-t>', '<cmd>Telescope live_grep<CR>')
