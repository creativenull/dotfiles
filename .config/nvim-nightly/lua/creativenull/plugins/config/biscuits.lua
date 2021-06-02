require 'nvim-biscuits'.setup {
  default_config = {
    max_length = 32,
    min_distance = 32,
    prefix_string = ' 🔎 ',
    on_events = {
      'InsertLeave',
      'CursorHoldI',
    },
  },
}
