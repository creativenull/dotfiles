local M = {}

function M.setup()
  vim.g.codeium_enabled = true
  vim.g.codeium_filetypes = {
    ['fern-replacer'] = false,
  }
end

return M
