local imap = require('cnull.core.keymap').imap

require('compe').setup({
  source = {
    nvim_lsp  = true,
    ultisnips = true,
  },
})

vim.opt.pumheight = 10

imap('<C-Space>', [=[compe#complete()]=], { expr = true, noremap = false })
imap('<Tab>', [=[compe#confirm('<Tab>')]=], { expr = true, noremap = false })
