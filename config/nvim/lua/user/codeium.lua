local M = {}

function M.setup()
  require("codeium").setup({
    enable_cmp_source = false,
    virtual_text = {
      enabled = true,
      filetypes = { ["fern-replacer"] = false },
      map_keys = false,
      key_bindings = {
        accept = "<Tab>",
        accept_word = false,
        accept_line = false,
        next = "<C-]>",
        prev = "<C-[>",
        clear = "<C-x>",
      },
    },
  })
end

return M
