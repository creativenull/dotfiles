local plugins = {
  'surround',
  'abolish',
  'repeat',

  'json',

  'autopairs',
  'biscuits',
  'bufferline',

  'vsnip',
  -- 'cmp',

  'comment',
  'colorizer',
  'emmet',
  'gitsigns',
  'indent_blankline',
  'lir',
  'lspconfig',
  'lualine',
  'telescope',
  'treesitter',
}

for _, plugin in pairs(plugins) do
  local ok, e = pcall(require, string.format('user.plugins.%s', plugin))

  if not ok then
    vim.notify(e, vim.log.levels.ERROR)
  end
end
