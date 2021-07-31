local imap = require 'cnull.core'.keymap.imap

local M = {
  plugins = {
    {'hrsh7th/nvim-compe'},
  },
}

function M.after()
  require 'compe'.setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 3,
    preselect = 'enable',
    throttle_time = 80,
    source_timeout = 200,
    resolve_timeout = 800,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = {
      border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
      winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
      max_width = 120,
      min_width = 60,
      max_height = math.floor(vim.o.lines * 0.3),
      min_height = 1,
    },
    source = {
      nvim_lsp  = true,
      ultisnips = true,
    },
  }

  vim.opt.pumheight = 10

  imap('<C-Space>', [[compe#complete()]], { expr = true, noremap = false })
  imap('<Tab>', [[compe#confirm('<Tab>')]], { expr = true, noremap = false })
end

return M
