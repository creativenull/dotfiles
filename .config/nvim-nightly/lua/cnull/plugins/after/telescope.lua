local nmap = require 'cnull.core.keymap'.nmap
local telescope = require 'telescope'
local telescope_builtin = require 'telescope.builtin'

telescope.setup {
  defaults = {
    layout_config = {
      prompt_position = 'top',
    },
    layout_strategy = 'horizontal',
    sorting_strategy = 'ascending',
    use_less = false,
  },
}

-- Normal file finder
local function find_files()
  telescope_builtin.find_files {
    find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
    previewer = false,
  }
end
nmap('<Leader>p', find_files)

-- Code finder
local function live_grep()
  telescope_builtin.live_grep {}
end
nmap('<Leader>t', live_grep)

-- Config file finder
local function find_config_files()
  local configdir = string.format('%s/.config/%s', vim.env.HOME, _G.rc_namespace)
  telescope_builtin.find_files {
    find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden', configdir },
    previewer = false
  }
end
nmap('<leader>vf', find_config_files)
