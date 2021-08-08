local nmap = require 'cnull.core'.keymap.nmap

local M = {
  plugins = {
    {'steelsojka/pears.nvim'},
    {'creativenull/projectcmd.nvim'},
    {'editorconfig/editorconfig-vim'},
    {'kevinhwang91/nvim-bqf'},
    {'mcchrish/nnn.vim'},
    {'tpope/vim-abolish', opt = true},
    {'tpope/vim-surround', opt = true},
  },
}

function M.before()
  -- lexima.vim Config
  vim.g.lexima_no_default_rules = true
end

function M.after()
  -- projectcmd.nvim Config
  -- require('projectcmd').setup {}

  -- nnn.vim Config
  require('nnn').setup {
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

  -- pears.nvim Config
  require('pears').setup()
end

return M
