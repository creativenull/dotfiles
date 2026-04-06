local M = {}

function M.setup()
  local disabled = { "lua", "vim", "help" }
  local parser_install_dir = vim.fn.stdpath("data") .. "/treesitter"

  local ft = {
    "astro",
    "blade",
    "css",
    "go",
    "html",
    "javascript",
    "json",
    "kitty",
    "lua",
    "nix",
    "php",
    "prisma",
    "sql",
    "svelte",
    "todotxt",
    "tsx",
    "typescript",
    "vimdoc",
    "vue",
  }

  require("nvim-treesitter").setup({ install_dir = parser_install_dir })
  require("nvim-treesitter").install(ft)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = ft,
    callback = function(ev)
      local filetype = vim.api.nvim_buf_get_option(ev.buf, "filetype")
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(ev.buf))

      if ok and stats and stats.size > max_filesize then
        return
      end

      if not vim.tbl_contains(disabled, filetype) then
        -- exclude from disabled list
        vim.treesitter.start()
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufNew", "BufNewFile", "BufWinEnter" }, {
    group = vim.g.user.event,
    callback = function()
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 1
      vim.opt.foldtext = ""

      vim.opt.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })

  require("nvim-treesitter-textobjects").setup({
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ["@parameter.outer"] = "v", -- charwise
        ["@function.outer"] = "V", -- linewise
        ["@class.outer"] = "<c-v>", -- blockwise
      },

      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = true,
    },
  })

  vim.keymap.set({ "x", "o" }, "af", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "if", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "ac", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "ic", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "as", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
  end)
end

return M
