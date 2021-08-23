local M = {
  plugins = {
    -- {'hrsh7th/nvim-compe'},
    {'ms-jpq/coq_nvim', branch = 'coq'},
    {'ms-jpq/coq.artifacts', branch = 'artifacts'},
  },
}

--[[ function M.after()
  local imap = require('cnull.core.keymap').imap

  -- compe.nvim Config
  -- ---
  require('compe').setup({
    source = {
      nvim_lsp  = true,
      ultisnips = true,
    },
  })

  vim.opt.pumheight = 10

  imap('<C-Space>', [=[compe#complete()]=], { expr = true, noremap = false })
  imap('<Tab>', [=[compe#confirm('<Tab>')]=], { expr = true, noremap = false })
end ]]

return M
