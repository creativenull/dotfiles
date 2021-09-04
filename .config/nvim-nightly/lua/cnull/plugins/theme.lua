local M = {
  plugins = {
    {'norcalli/nvim-colorizer.lua', opt = true},
    {'bluz71/vim-moonfly-colors'},
    {'bluz71/vim-nightfly-guicolors'},
    {'marko-cerovac/material.nvim'},
    {'EdenEast/nightfox.nvim'},
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
        vim.cmd('packadd nvim-colorizer.lua')
        require('colorizer').setup()
      end,
    },
  })
end

return M
