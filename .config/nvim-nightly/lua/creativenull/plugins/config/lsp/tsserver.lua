local M = {}

-- tsserver organize imports
-- https://www.reddit.com/r/neovim/comments/lwz8l7/how_to_use_tsservers_organize_imports_with_nvim/gpkueno?utm_source=share&utm_medium=web2x&context=3
local function ts_organize_imports()
  vim.lsp.buf.execute_command({
    command = '_typescript.organizeImports',
    arguments = { vim.api.nvim_buf_get_name(0) }
  })
end

M.organize_cmd = {
  TsOrganizeImports = { ts_organize_imports, description = 'Organize imports' }
}

return M
