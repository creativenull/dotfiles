local M = {}

local function vim_grep(args, bang)
  local query = ""
  if args ~= nil then
    query = vim.fn.shellescape(args)
  end

  local sh = "rg --column --line-number --no-heading --color=always --smart-case -- " .. query
  vim.call("fzf#vim#grep", sh, 1, vim.call("fzf#vim#with_preview", vim.empty_dict()), bang)
end

local function vim_grep_files(args, bang)
  local query = ""
  if args ~= nil then
    query = args
  end


  local sh = "rg --with-filename --no-heading --column --line-number --no-heading --color=always --smart-case -- " .. query
  vim.call("fzf#vim#grep", sh, 1, vim.call("fzf#vim#with_preview", vim.empty_dict()), bang)
end

local function fzf_window_setup()
  local buf = vim.api.nvim_get_current_buf()
  vim.opt.ruler = false

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    callback = function()
      vim.opt.ruler = true
    end,
  })
end

function M.setup()
  vim.env.FZF_DEFAULT_COMMAND = "rg --files --hidden --iglob !.git"
  -- vim.env.FZF_DEFAULT_OPTS = table.concat({
  --   "--reverse",
  --   "--color=border:#aaaaaa,gutter:-1,bg+:-1",
  -- }, " ")

  vim.g.fzf_vim = {
    preview_window = {},
    grep_multi_line = 1,
  }

  vim.api.nvim_create_user_command("Rg", function(c)
    vim_grep(c.args, c.bang)
  end, { bang = true, nargs = "*" })

  vim.api.nvim_create_user_command("RgFiles", function(c)
    vim_grep_files(c.args, c.bang)
  end, { bang = true, nargs = "*" })

  vim.keymap.set("n", "<C-p>", "<Cmd>Files<CR>", { desc = "List files in the current directory" })
  vim.keymap.set("n", "<C-t>", "<Cmd>Rg<CR>", { desc = "Open the grep interface in the current directory" })
  vim.keymap.set("n", "<C-y>", function()
    vim_grep(vim.fn.expand("<cword>"), false)
  end, { desc = "Grep for the word under the cursor in the current directory" })
  vim.keymap.set("n", "<C-Space>", "<Cmd>FzfxBuffers<CR>", { desc = "List open buffers" })

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.g.user.event,
    pattern = "fzf",
    callback = fzf_window_setup,
    desc = "(fzf.vim) Adjust settings on enter fzf window",
  })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.g.user.event,
    callback = function()
      vim.api.nvim_set_hl(0, "fzf1", { bg = "NONE" })
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    group = vim.g.user.event,
    pattern = "FzfStatusLine",
    callback = function(args)
      vim.wo[vim.fn.bufwinid(args.buf)].statusline = "%#fzf1# > fzf"
    end,
    desc = "(fzf.vim) Custom highlights",
  })
end

return M
