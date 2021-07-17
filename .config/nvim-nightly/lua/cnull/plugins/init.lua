local plugins = require 'cnull.plugins.plugins'
local hooks = require 'cnull.plugins.hooks'
local M = {}

local function packager_init(opts)
  require 'packager'.setup(plugins.setup, opts)
end

-- Package manager bootstrapping strategy
function M.init(config)
  local manager = {
    git = 'https://github.com/kristijanhusak/vim-packager.git',
    pack = 'vim-packager',
    install_path = vim.fn.stdpath('data') .. '/site/pack/packager/opt/vim-packager',
    config_dir = vim.fn.stdpath('config'),
    init = {
      dir = vim.fn.stdpath('data') .. '/site/pack/packager',
    },
  }

  if config and not vim.tbl_isempty(config) then
    manager = vim.tbl_extend('force', manager, config)
  end

  return {
    setup = function()
      -- On before hook
      hooks.on_before_plugins(manager)

      if vim.fn.isdirectory(manager.install_path) == 0 then
        -- Install plugin manager
        vim.cmd(string.format('!git clone %s %s', manager.git, manager.install_path))

        -- Install plugins
        vim.cmd('packadd ' .. manager.pack)
        packager_init(manager.init)
        vim.cmd [[ PackagerInstall ]]
      else
        vim.cmd('packadd ' .. manager.pack)
        packager_init(manager.init)
      end

      -- On after hook
      hooks.on_after_plugins(manager)
    end
  }
end

return M
