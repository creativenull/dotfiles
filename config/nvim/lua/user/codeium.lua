local M = {}

function M.setup()
  vim.g.codeium_enabled = true
  vim.g.codeium_disable_bindings = true
  vim.g.codeium_filetypes = {
    ["fern-replacer"] = false,
  }

  vim.keymap.set("i", "<Tab>", function()
    return vim.call("codeium#Accept")
  end, { expr = true, silent = true })
  vim.keymap.set("i", "<c-]>", function()
    return vim.call("codeium#CycleCompletions", 1)
  end, { expr = true, silent = true })
  vim.keymap.set("i", "<C-[>", function()
    return vim.call("codeium#CycleCompletions", -1)
  end, { expr = true, silent = true })
  vim.keymap.set("i", "<C-x>", function()
    return vim.fn["codeium#Clear"]()
  end, { expr = true, silent = true })
end

return M
