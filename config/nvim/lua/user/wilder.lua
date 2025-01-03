local wilder = require("wilder")
local M = {}

function M.setup()
  wilder.setup({
    modes = { ":", "/", "?" },
    next_key = "<C-n>",
    previous_key = "<C-p>",
  })

  -- Additional overrides
  vim.keymap.set("c", "<Tab>", 'wilder#in_context() ? wilder#next() : "\\<Tab>"', { expr = true })
  vim.keymap.set("c", "<S-Tab>", 'wilder#in_context() ? wilder#previous() : "\\<S-Tab>"', { expr = true })

  wilder.set_option("pipeline", {
    wilder.branch(
      wilder.cmdline_pipeline({
        fuzzy = 1,
        set_pcre2_pattern = 1,
      }),
      wilder.python_search_pipeline({
        pattern = "fuzzy",
      })
    ),
  })

  wilder.set_option(
    "renderer",
    wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
      border = "rounded",
      empty_message = wilder.popupmenu_empty_message_with_spinner(),
      highlighter = wilder.basic_highlighter(),
      left = { " ", wilder.popupmenu_devicons() },
      right = { " ", wilder.popupmenu_scrollbar() },
    }))
  )
end

return M
