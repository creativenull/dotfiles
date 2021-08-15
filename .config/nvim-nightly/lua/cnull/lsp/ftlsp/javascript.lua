local fn = vim.fn
local api = vim.api

local tsserver_exec = 'typescript-language-server'
if fn.executable(tsserver_exec) == 0 then
  api.nvim_err_writeln(string.format('lsp: %q is not installed', tsserver_exec))
  return
end

local deno_exec = 'deno'
if fn.executable(deno_exec) == 0 then
  api.nvim_err_writeln(string.format('lsp: %q is not installed`', deno_exec))
  return
end

local root_pattern = require('lspconfig').util.root_pattern
local filetypes = {'javascript', 'javascriptreact', 'javascript.jsx'}
local node_root = fn.getcwd() .. '/package.json'
local deno_root = fn.getcwd() .. '/import_map.json'

local is_node = fn.filereadable(node_root) == 1
local is_deno = fn.filereadable(deno_root) == 1
if is_node then
  require('cnull.core.lsp').setup('tsserver', {
    filetypes = filetypes,
    root_dir = root_pattern('package.json', 'jsconfig.json'),
    flags = {
      debounce_text_changes = 500,
    },
  })
elseif is_deno then
  require('cnull.core.lsp').setup('denols', {
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
