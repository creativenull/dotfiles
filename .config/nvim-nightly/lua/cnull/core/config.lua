local M = {}

local errmsg_pkg_required = 'not installed, install via OS pkg manager (required)'
local errmsg_pkg_optional = 'not installed, install via OS pkg manager (optional)'

-- Perform pre-requisite checks before setting nvim config
-- @return nil
local function prereq_checks()
  if vim.fn.executable('python3') == 0 or vim.env.PYTHON3_HOST_PROG == nil then
    error(string.format('%q %s', 'python3', errmsg_pkg_required))
  end

  if vim.fn.executable('rg') == 0 then
    error(string.format('%q %s', 'ripgrep', errmsg_pkg_required))
  end

  if vim.fn.executable('nnn') == 0 then
    error(string.format('%q %s', 'nnn', errmsg_pkg_required))
  end

  if vim.fn.executable('bat') == 0 then
    vim.api.nvim_err_writeln(string.format('%q %s', 'bat', errmsg_pkg_optional))
  end
end

-- Setup initial configuration for nvim config
-- @param table config
-- @return nil
function M.init(config)
  prereq_checks()

  local default_config = {
    ns = 'nvim',
    leader = ',',
    localleader = [[\]],
    theme = {
      name = 'default',
      transparent = false,
    },
    keymaps = {},
  }

  _G.CNull = {
    config = vim.tbl_extend('force', default_config, config),
    events = {},
    commands = {},
    keymaps = {},
  }

  return _G.CNull.config
end

return M
