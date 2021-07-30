local nmap = require 'cnull.core'.keymap.nmap

require 'nvim-biscuits'.setup {
  default_config = {
    cursor_line_only = true,
    max_length = 32,
    min_distance = 10,
    prefix_string = ' 🔎 ',
    on_events = {
      'InsertLeave',
      'CursorHoldI',
    },
  },
}

nmap('<Leader>cb', function() require 'nvim-biscuits'.toggle_biscuits() end)
