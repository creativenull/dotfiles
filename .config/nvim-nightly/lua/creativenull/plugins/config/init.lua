local M = {}

function M.init()
  require 'creativenull.plugins.config.emmet'
end

function M.setup()
  require 'creativenull.plugins.config.projectcmd'
  require 'creativenull.plugins.config.compe'
  require 'creativenull.plugins.config.gitsigns'
  require 'creativenull.plugins.config.telescope'
  require 'creativenull.plugins.config.lsp'
  require 'creativenull.plugins.config.autopairs'

  -- treesitter and co
  require 'creativenull.plugins.config.treesitter'
  require 'creativenull.plugins.config.biscuits'
end

return M
