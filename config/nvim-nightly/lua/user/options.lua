if vim.fn.isdirectory(_G.User.config.undoDir) == 0 then
  vim.cmd(string.format('silent !mkdir -p %s', _G.User.config.undoDir))
end

-- Completion
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
vim.opt.shortmess:append('c')

-- Search
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.path = '**'

-- Editor
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.colorcolumn = '120'
vim.opt.scrolloff = 3
vim.opt.lazyredraw = true
vim.opt.spell = false
vim.opt.wildignorecase = true

-- System
vim.opt.encoding = 'utf-8'
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.updatetime = 250
vim.opt.undofile = true
vim.opt.undodir = _G.User.config.undoDir
vim.opt.undolevels = 10000
vim.opt.history = 10000
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.ttimeoutlen = 50
vim.opt.mouse = ''

-- UI
vim.opt.hidden = true
vim.opt.signcolumn = 'yes'
vim.opt.cmdheight = 2
vim.opt.showtabline = 2
vim.opt.laststatus = 3
vim.opt.guicursor = { 'n-v-c-sm:block', 'i-ci-ve:block', 'r-cr-o:hor20' }
vim.opt.termguicolors = true
vim.opt.number = true
