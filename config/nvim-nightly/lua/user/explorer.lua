local lir = require('lir')
local lir_actions = require('lir.actions')
local lir_mark_actions = require('lir.mark.actions')
local lir_clipboard_actions = require('lir.clipboard.actions')

lir.setup({
  show_hidden_files = true,
  devicons_enable = true,
  hide_cursor = true,
  float = {
    winblend = 0,
    win_opts = function()
      return {
        border = 'rounded',
      }
    end,
  },
  mappings = {
    ['l'] = lir_actions.edit,
    ['<CR>'] = lir_actions.edit,
    ['<C-s>'] = lir_actions.split,
    ['<C-v>'] = lir_actions.vsplit,
    ['<C-t>'] = lir_actions.tabedit,

    ['h'] = lir_actions.up,
    ['q'] = lir_actions.quit,

    ['K'] = lir_actions.mkdir,
    ['N'] = lir_actions.newfile,
    ['R'] = lir_actions.rename,
    ['@'] = lir_actions.cd,
    ['Y'] = lir_actions.yank_path,
    ['.'] = lir_actions.toggle_show_hidden,
    ['D'] = lir_actions.delete,

    ['J'] = function()
      lir_mark_actions.toggle_mark()
      vim.cmd('normal! j')
    end,

    ['C'] = lir_clipboard_actions.copy,
    ['X'] = lir_clipboard_actions.cut,
    ['P'] = lir_clipboard_actions.paste,
  },
})

vim.keymap.set('n', '<Leader>ff', function()
  require('lir.float').toggle()
end, { desc = 'Open File Explorer' })
