local M = {
  plugins = {
    {'norcalli/nvim-colorizer.lua'},
    {'folke/tokyonight.nvim'},
    {'glepnir/zephyr-nvim'},
    {'bluz71/vim-moonfly-colors'},
  },
}

function M.after()
  local augroup = require('cnull.core.event').augroup

  -- nvim-colorizer.lua Config
  -- ---
  augroup('user_colorizer_events', {
    {
      event = 'ColorScheme',
      exec = function()
        require('colorizer').setup()
      end,
    },
  })
end

return M
