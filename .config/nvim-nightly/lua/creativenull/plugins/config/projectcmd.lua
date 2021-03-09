local M = {}

M.config = function()
  require 'projectcmd'.setup {
    key = os.getenv('NVIMRC_PROJECTCMD_KEY'),
    type = 'lua',
    autoload = true
  }
end

return M
