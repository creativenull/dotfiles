local nmap = require 'cnull.core.keymap'.nmap

require 'nnn'.setup {
  set_default_mappings = false,
  layout = {
    window = {
      width = 0.9,
      height = 0.6,
      highlight = 'Debug',
    },
  },
}

nmap('<Leader>ff', [[<Cmd>NnnPicker %:p:h<CR>]])
