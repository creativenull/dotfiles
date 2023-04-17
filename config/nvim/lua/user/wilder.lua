local wilder = require('wilder')
local M = {}

function M.setup()
  wilder.setup({ modes = { ':', '/', '?' } })

  wilder.set_option('pipeline', {
    wilder.branch(
      wilder.cmdline_pipeline({
        fuzzy = 1,
        set_pcre2_pattern = 1,
      }),
      wilder.python_search_pipeline({
        pattern = 'fuzzy',
      })
    ),
  })

  wilder.set_option(
    'renderer',
    wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
      border = 'rounded',
      empty_message = wilder.popupmenu_empty_message_with_spinner(),
      highlighter = wilder.basic_highlighter(),
      left = { ' ', wilder.popupmenu_devicons() },
      right = { ' ', wilder.popupmenu_scrollbar() },
    }))
  )
end

return M
