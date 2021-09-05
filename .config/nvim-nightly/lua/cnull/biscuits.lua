require('nvim-biscuits').setup({
  default_config = {
    cursor_line_only = true,
    max_length = 32,
    min_distance = 10,
    prefix_string = ' 🔎 ',
    on_events = {
      'InsertLeave',
      'CursorHoldI',
    },
  },
})

function _G.ToggleBiscuits()
  require('nvim-biscuits').toggle_biscuits()
end
