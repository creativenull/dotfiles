local M = {
  plugins = {
    {'nvim-telescope/telescope.nvim'},
    -- {'junegunn/fzf'},
    -- {'junegunn/fzf.vim'},
    -- {'camspiers/snap'},
  },
}

function M.before()
  -- fzf.vim Config
  -- ---
  -- require('cnull.plugins.finders.fzf').before()
end

function M.after()
  -- fzf.vim Config
  -- ---
  -- require('cnull.plugins.finders.fzf').after()

  -- telescope.nvim Config
  -- ---
  require('cnull.plugins.finders.telescope')

  -- snap Config
  -- ---
  -- require('cnull.plugins.finders.snap')
end

return M
