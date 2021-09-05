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

function _G.TelescopeFindFiles()
  telescope_builtin.find_files({
    find_command = {'rg', '--files', '--iglob', '!.git', '--hidden'},
    previewer = false,
  })
end

function _G.TelescopeLiveGrep()
  telescope_builtin.live_grep({})
end

function _G.TelescopeFindConfigFiles()
  local configdir = vim.fn.stdpath('config')
  telescope_builtin.find_files({
    find_command = {'rg', '--files', '--iglob', '!.git', '--hidden', configdir},
    previewer = false,
  })
end
