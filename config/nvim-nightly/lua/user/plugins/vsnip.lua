vim.g.vsnip_extra_mapping = false
vim.g.vsnip_filetypes = {
  javascriptreact = { 'javascript' },
  typescriptreact = { 'typescript' },
}

vim.keymap.set({ 'i', 's' }, '<C-j>', [[vsnip#jumpable(1) ? "\<Plug>(vsnip-jump-next)" : "\<C-j>"]], {
  expr = true,
  replace_keycodes = true,
  remap = true,
})

vim.keymap.set({ 'i', 's' }, '<C-k>', [[vsnip#jumpable(-1) ? "\<Plug>(vsnip-jump-prev)" : "\<C-k>"]], {
  expr = true,
  replace_keycodes = true,
  remap = true,
})
