local imap = require 'cnull.core.keymap'.imap

require 'compe'.setup {
  min_length = 2,
  source = {
    buffer = true,
    nvim_lsp  = true,
    path = true,
    ultisnips = true,
  },
}

vim.g.lexima_no_default_rules = true
vim.fn['lexima#set_default_rules']()

imap('<C-Space>', [[compe#complete()]], { expr = true, noremap = false })
imap('<C-y>', [[compe#confirm(lexima#expand('<LT>CR>', 'i'))]], { expr = true, noremap = false })
