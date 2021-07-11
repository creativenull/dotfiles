local augroup = require 'cnull.core.event'.augroup

local M = {}

local function register_transparent_event(theme)
  if theme.transparent then
    augroup('transparent_bg_events', {
      { event = 'ColorScheme', exec = [[highlight Normal guibg=NONE]] },
      { event = 'ColorScheme', exec = [[highlight SignColumn guibg=NONE]] },
      { event = 'ColorScheme', exec = [[highlight LineNr guifg=#cccccc guibg=NONE]] },
      { event = 'ColorScheme', exec = [[highlight CursorLineNr guibg=NONE]] },
      { event = 'ColorScheme', exec = [[highlight Terminal guibg=NONE]] },
      { event = 'ColorScheme', exec = [[highlight EndOfBuffer guibg=NONE]] },
      { event = 'ColorScheme', exec = [[highlight FoldColumn guibg=NONE]] },
      { event = 'ColorScheme', exec = [[highlight Folded guibg=NONE]] },
      { event = 'ColorScheme', exec = [[highlight ToolbarLine guibg=NONE]] },
      { event = 'ColorScheme', exec = [[highlight Comment guifg=#888888]] },
    })
  end
end

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

  if vim.g.loaded_colorizer then
    require 'colorizer'.setup()
  end
end

function M.setup(cfg)
  local theme = cfg.theme
  register_transparent_event(theme)
  set_colorscheme(theme)
end

return M