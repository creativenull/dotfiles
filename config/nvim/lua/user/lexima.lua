local M = {}

function M.setup()
  -- enable rules
  vim.g.lexima_enable_endwise_rules = 1
  vim.g.lexima_enable_newline_rules = 1

  -- Auto close function, if and for in lua
  vim.call('lexima#add_rule', {
    char = '<CR>',
    input = '<CR>',
    input_after = '<CR>end',
    at = [[\%(^\s*#.*\)\@<!\<\%(function\)\>\%(.*\<end\>\)\@!.*\%#]],
    except = [[\C\v^(\s*)\S.*%#\n%(%(\s*|\1\s.+)\n)*\1end]],
    filetype = 'lua',
    syntax = {},
  })
  vim.call('lexima#add_rule', {
    char = '<CR>',
    input = '<CR>',
    input_after = '<CR>end',
    at = [[\%(^\s*#.*\)\@<!\s*\<\%(do\|then\)\s*\%#]],
    except = [[\C\v^(\s*)\S.*%#\n%(%(\s*|\1\s.+)\n)*\1end]],
    filetype = 'lua',
    syntax = {},
  })
end

return M
