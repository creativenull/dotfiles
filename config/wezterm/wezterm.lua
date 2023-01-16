local wezterm = require('wezterm')

local font_size = 12
if string.find(wezterm.target_triple, 'darwin') ~= nil then
  font_size = 14
end

return {
  font = wezterm.font('JetBrainsMono Nerd Font'),
  font_size = font_size,
  line_height = 2,
  window_padding = {
    top = 0,
    right = 0,
    bottom = 0,
    left = 0,
  },
  colors = {
    cursor_bg = '#e5e5e5',
    cursor_fg = '#171717',
  },
  window_frame = {
    font = wezterm.font('JetBrainsMono Nerd Font'),
  },
}
