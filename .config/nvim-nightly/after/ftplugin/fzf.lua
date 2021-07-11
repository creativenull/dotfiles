local autocmd = require 'cnull.core'.autocmd

local function on_buf_leave()
  vim.opt.laststatus = 2
  vim.opt.ruler = true
end

vim.opt.laststatus = 0
vim.opt.ruler = false
autocmd {
  clear = true,
  event = 'BufLeave',
  pattern = '<buffer>',
  exec = on_buf_leave
}
