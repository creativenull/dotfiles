local M = {}

-- Perform pre-requisite checks before setting nvim config
-- @return void
local function prereq_checks()
  if vim.fn.executable('python3') == 0 or vim.fn.exists('$PYTHON3_HOST_PROG') == 0 then
    error('`python3` not installed, please install it via your OS software manager, and set $PYTHON_HOST_PROG env')
  end

  if vim.fn.executable('rg') == 0 then
    error('`ripgrep` not installed, please install it via your OS software manager')
  end

  if vim.fn.executable('nnn') == 0 then
    error('`nnn` not installed, please install it via your OS software manager')
  end
end

-- Setup initial configuration for nvim config
--
-- @param table config
-- @return void
function M.init(config)
  prereq_checks()

  local default_config = {
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
