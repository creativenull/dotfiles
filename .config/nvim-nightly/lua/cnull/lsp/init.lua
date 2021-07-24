local mod = (...):gsub('%.init$', '')
local M = {}

-- @param table lspname
-- @return void
function M.setup(filetypes)
  if not filetypes or vim.tbl_isempty(filetypes) then
    return
  end

  for _,ft in pairs(filetypes) do
    local ftmod = string.format('%s.ftlsp.%s', mod, ft)
    local success = pcall(require , ftmod)
    if not success then
      vim.api.nvim_err_writeln(string.format('lsp: could not require the lsp configuration for %q filetype', ft))
    end
  end
end

return M
