local augroup = require('cnull.core.event').augroup
local M = {}

-- Set transparent colors when on
-- @param table theme
-- @return nil
local function register_transparent_event(theme)
  if theme.transparent then
    augroup('transparent_bg_events', {
      { event = 'ColorScheme', exec = 'highlight Normal guibg=NONE' },
      { event = 'ColorScheme', exec = 'highlight SignColumn guibg=NONE' },
      { event = 'ColorScheme', exec = 'highlight LineNr guifg=#888888 guibg=NONE' },
      { event = 'ColorScheme', exec = 'highlight CursorLineNr guibg=NONE' },
      { event = 'ColorScheme', exec = 'highlight Terminal guibg=NONE' },
      { event = 'ColorScheme', exec = 'highlight EndOfBuffer guibg=NONE' },
      { event = 'ColorScheme', exec = 'highlight FoldColumn guibg=NONE' },
      { event = 'ColorScheme', exec = 'highlight Folded guibg=NONE' },
      { event = 'ColorScheme', exec = 'highlight ToolbarLine guibg=NONE' },
      { event = 'ColorScheme', exec = 'highlight Comment guifg=#888888' },
    })
  end
end

-- Set the colorscheme of vim
-- @param table theme
-- @return nil
local function set_colorscheme(theme)
  vim.opt.number = true
  vim.opt.termguicolors = true

  if theme.setup then
    theme.setup()
  end

  vim.api.nvim_command('colorscheme ' .. theme.name)
  if vim.g.colors_name ~= theme.name then
    vim.g.colors_name = theme.name
  end
end

-- Colorscheme setup for transparency and theme
-- @param table cfg
-- @return nil
function M.setup(cfg)
  local theme = cfg.theme
  register_transparent_event(theme)
  set_colorscheme(theme)
end

return M
