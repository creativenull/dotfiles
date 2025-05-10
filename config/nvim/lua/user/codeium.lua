local M = {}

function M.setup()
  require("codeium").setup({
    enable_cmp_source = false,
    virtual_text = {
      enabled = true,
      filetypes = { ["fern-replacer"] = false },
      map_keys = true,
      key_bindings = {
        accept = "<Tab>",
        accept_word = false,
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        clear = false,
      },
    },
  })
end

return M
