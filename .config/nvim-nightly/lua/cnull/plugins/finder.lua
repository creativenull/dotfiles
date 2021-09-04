local M = {
  plugins = {
    {'nvim-telescope/telescope.nvim', requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'}},
    -- {'junegunn/fzf.vim', requires = {'junegunn/fzf', run = function() vim.fn['fzf#install']() end}},
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
