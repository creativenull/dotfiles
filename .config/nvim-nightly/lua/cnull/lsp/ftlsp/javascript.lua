local tsserver_executable = 'typescript-language-server'
local deno_executable = 'deno'

if vim.fn.executable(tsserver_executable) == 0 then
  vim.api.nvim_err_writeln(string.format('lsp: %q is not installed', tsserver_executable))
  return
end

if vim.fn.executable(deno_executable) == 0 then
  vim.api.nvim_err_writeln(string.format('lsp: %q is not installed`', deno_executable))
  return
end

local root_pattern = require 'lspconfig'.util.root_pattern
local filetypes = {'javascript', 'javascriptreact', 'javascript.jsx'}
local node_root = vim.fn.getcwd() .. '/package.json'
local deno_root = vim.fn.getcwd() .. '/import_map.json'

local is_node = vim.fn.filereadable(node_root) == 1
local is_deno = vim.fn.filereadable(deno_root) == 1
if is_node then
  require 'cnull.core.lsp'.setup('tsserver', {
    filetypes = filetypes,
    root_dir = root_pattern('package.json', 'jsconfig.json'),
    flags = {
      debounce_text_changes = 500,
    },
  })
elseif is_deno then
  require 'cnull.core.lsp'.setup('denols', {
    filetypes = filetypes,
    root_dir = root_pattern('import_map.json', '.denols'),
    init_options = {
      enable = true,
      lint = true,
      unstable = true,
      importMap = deno_root,
    },
    flags = {
      debounce_text_changes = 500,
    },
  })
end
