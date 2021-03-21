local o = vim.o -- global
local wo = vim.wo -- window

-- Completion options
if string.match(o.shortmess, 'c') == nil then
  -- Append only once on source
  o.shortmess = vim.o.shortmess .. 'c'
end
o.completeopt = 'menuone,noinsert,noselect'
o.updatetime = 100

-- Search options
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true
o.wrapscan = true

-- Indent options
o.tabstop = 4
o.shiftwidth = 0
o.softtabstop = 4
o.expandtab = true
o.autoindent = true
o.smartindent = true
o.smarttab = true

-- Line options
o.showmatch = true
o.showbreak = '+++'
o.textwidth = 120
o.scrolloff = 5
wo.linebreak = true
wo.colorcolumn = '120' -- some prefer 80, but I just like to break the rules :)

-- Move swapfiles and backups into cache
o.directory = os.getenv('HOME') .. '/.cache/nvim-nightly'
o.backup = true
o.backupdir = os.getenv('HOME') .. '/.cache/nvim-nightly'

-- Enable the integrated undo features
o.undofile = true
o.undodir = os.getenv('HOME') .. '/.cache/nvim-nightly'
o.undolevels = 1000
o.history = 1000

-- Lazy redraw
o.lazyredraw = true

-- Buffers/Tabs/Windows
o.hidden = true

-- Set spelling
o.spell = false

-- For git
wo.signcolumn = 'yes'

-- Mouse support
o.mouse = 'a'

-- backspace behaviour
o.backspace = 'indent,eol,start'

-- Status line
o.showmode = false
o.statusline = require 'creativenull.statusline'.get_statusline()

-- Tab line
o.showtabline = 2
o.tabline = require 'creativenull.tabline'.get_tabline()

-- Better display
o.cmdheight = 2

-- Auto reload file if changed outside vim, or just :e!
o.autoread = true

-- Invisible chars list
wo.list = true
o.listchars = [[tab:▸ ,trail:·,space:·]]
