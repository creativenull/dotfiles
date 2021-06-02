-- Completion options
vim.opt.shortmess:append('c')
vim.opt.completeopt = 'menuone,noinsert,noselect'
vim.opt.updatetime = 250

-- Search options
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true

-- Indent options
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true

-- Line options
vim.opt.showmatch = true
vim.opt.showbreak = '+++'
vim.opt.textwidth = 120
vim.opt.scrolloff = 5
vim.opt.linebreak = true
vim.opt.colorcolumn = '120'

-- Move swapfiles and backups into cache
vim.opt.directory = vim.env.HOME .. '/.cache/nvim-nightly'
vim.opt.backup = true
vim.opt.backupdir = vim.env.HOME .. '/.cache/nvim-nightly'

-- Enable the integrated undo features
vim.opt.undofile = true
vim.opt.undodir = vim.env.HOME .. '/.cache/nvim-nightly'
vim.opt.undolevels = 10000
vim.opt.history = 10000

-- Lazy redraw
vim.opt.lazyredraw = true

-- Buffers/Tabs/Windows
vim.opt.hidden = true

-- Set spelling
vim.opt.spell = false

-- For git
vim.opt.signcolumn = 'yes'

-- No mouse support
vim.opt.mouse = ''

-- backspace behaviour
vim.opt.backspace = 'indent,eol,start'

-- Status line
vim.opt.showmode = false

-- Tab line
vim.opt.showtabline = 2

-- Better display
vim.opt.cmdheight = 2

-- Auto reload file if changed outside vim, or just :e!
vim.opt.autoread = true
