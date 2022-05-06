--[[ ==========================================================================
Name: Arnold Chand

Github: https://github.com/creativenull

Description:
  My init.vim, sort of cross-platform but very experimental, requires:
    + curl (globally installed)
    + git (globally installed)
    + python3 (globally installed)
    + ripgrep (globally installed)
    + deno (globally installed)
============================================================================ ]]

vim.g.userspace = 'nvim-nightly'

if vim.g.userspace then
  -- Runtime Path
  vim.cmd('set runtimepath-=~/.config/nvim')
  vim.cmd('set runtimepath-=~/.config/nvim/after')
  vim.cmd('set runtimepath-=~/.local/share/nvim/site')
  vim.cmd('set runtimepath-=~/.local/share/nvim/site/after')
  vim.cmd('set runtimepath-=/etc/xdg/nvim')
  vim.cmd('set runtimepath-=/etc/xdg/nvim/after')
  vim.cmd('set runtimepath-=/usr/share/nvim/site')
  vim.cmd('set runtimepath-=/usr/share/nvim/site/after')
  vim.cmd('set runtimepath-=/usr/local/share/nvim/site')
  vim.cmd('set runtimepath-=/usr/local/share/nvim/site/after')

  vim.cmd(string.format('set runtimepath+=~/.config/%s/after', vim.g.userspace))
  vim.cmd(string.format('set runtimepath^=~/.config/%s', vim.g.userspace))
  vim.cmd(string.format('set runtimepath+=~/.local/share/%s/site/after', vim.g.userspace))
  vim.cmd(string.format('set runtimepath^=~/.local/share/%s/site', vim.g.userspace))

  -- Pack Path
  vim.cmd('set packpath-=~/.config/nvim')
  vim.cmd('set packpath-=~/.config/nvim/after')
  vim.cmd('set packpath-=~/.local/share/nvim/site')
  vim.cmd('set packpath-=~/.local/share/nvim/site/after')
  vim.cmd('set packpath-=/etc/xdg/nvim')
  vim.cmd('set packpath-=/etc/xdg/nvim/after')
  vim.cmd('set packpath-=/usr/local/share/nvim/site')
  vim.cmd('set packpath-=/usr/local/share/nvim/site/after')
  vim.cmd('set packpath-=/usr/share/nvim/site')
  vim.cmd('set packpath-=/usr/share/nvim/site/after')

  vim.cmd(string.format('set packpath^=~/.config/%s', vim.g.userspace))
  vim.cmd(string.format('set packpath+=~/.config/%s/after', vim.g.userspace))
  vim.cmd(string.format('set packpath^=~/.local/share/%s/site', vim.g.userspace))
  vim.cmd(string.format('set packpath+=~/.local/share/%s/site/after', vim.g.userspace))
end

if vim.fn.has('nvim') == 0 and vim.fn.has('nvim-0.8') == 0 then
  vim.api.nvim_err_writeln('This config is only for neovim nightly version aka EXPERIMENTAL!')

  return
end

-- Hard requirements for this config
local exec_list = { 'git', 'curl', 'python3', 'rg', 'deno' }

for _, exec in pairs(exec_list) do
  if vim.fn.executable(exec) == 0 then
    local errmsg = string.format('[nvim] %q is needed!', exec)
    vim.api.nvim_err_writeln(errmsg)

    return
  end
end

-- =============================================================================
-- = Initialize =
-- =============================================================================

vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.python3_host_prog = vim.fn.exepath('python3')

vim.g.mapleader = ' '

_G.User = {
  transparent = true,
  config = {
    configDir = '',
    dataDir = '',
    cacheDir = '',
    undoDir = '',
  },
}

if vim.g.userspace then
  _G.User.config.dataDir = string.format('%s/.local/share/%s', vim.env.HOME, vim.g.userspace)
  _G.User.config.cacheDir = string.format('%s/.cache/%s', vim.env.HOME, vim.g.userspace)
  _G.User.config.configDir = string.format('%s/.config/%s', vim.env.HOME, vim.g.userspace)
else
  _G.User.config.dataDir = vim.fn.stdpath('data')
  _G.User.config.cacheDir = vim.fn.stdpath('config')
  _G.User.config.configDir = vim.fn.stdpath('cache')
end

_G.User.config.undoDir = string.format('%s/undodir', _G.User.config.cacheDir)

-- =============================================================================
-- = Events (AUG) =
-- =============================================================================

require('user.events')

-- =============================================================================
-- = Options (OPT) =
-- =============================================================================

require('user.options')

-- =============================================================================
-- = Keybindings (KEY) =
-- =============================================================================

require('user.keymaps')

-- =============================================================================
-- = User Commands (CMD) =
-- =============================================================================

require('user.commands')

-- Command Abbreviations, I can't release my shift key fast enough :'(
vim.cmd('cnoreabbrev Q q')
vim.cmd('cnoreabbrev Qa qa')
vim.cmd('cnoreabbrev W w')
vim.cmd('cnoreabbrev Wq wq')

-- =============================================================================
-- = Plugin Manager (PLUG) =
-- =============================================================================

local plugins = {
  -- Self-maintenance
  { 'savq/paq-nvim', opt = true },

  -- Dependencies
  'kyazdani42/nvim-web-devicons',
  'lambdalisue/nerdfont.vim',
  'nvim-lua/plenary.nvim',
  'vim-denops/denops.vim',

  -- Core
  'creativenull/projectlocal-vim',
  { 'tpope/vim-surround', opt = true },
  { 'tpope/vim-abolish', opt = true },
  { 'tpope/vim-repeat', opt = true },
  { 'windwp/nvim-autopairs', opt = true },
  { 'numToStr/Comment.nvim', opt = true },

  -- File Explorer
  { 'tamago324/lir.nvim', opt = true },

  -- Linters + Formatters + LSP Client
  'neovim/nvim-lspconfig',
  { 'creativenull/diagnosticls-configs-nvim', opt = true },
  { 'creativenull/efmls-configs-nvim', opt = true },

  -- Snippet Engine + Presets
  'hrsh7th/vim-vsnip',
  'rafamadriz/friendly-snippets',
  { 'mattn/emmet-vim', opt = true },

  -- AutoCompletion + Sources
  { 'hrsh7th/nvim-cmp', opt = true },
  { 'hrsh7th/cmp-nvim-lsp', opt = true },
  { 'hrsh7th/cmp-buffer', opt = true },
  { 'hrsh7th/cmp-path', opt = true },
  { 'hrsh7th/cmp-nvim-lua', opt = true },
  { 'hrsh7th/cmp-vsnip', opt = true },
  { 'onsails/lspkind-nvim', opt = true },

  -- Fuzzy File/Code Finder
  { 'nvim-telescope/telescope.nvim', opt = true },

  -- Git
  { 'lewis6991/gitsigns.nvim', opt = true },

  -- UI
  { 'lukas-reineke/indent-blankline.nvim', opt = true },
  'akinsho/bufferline.nvim',
  'code-biscuits/nvim-biscuits',
  'norcalli/nvim-colorizer.lua',
  'nvim-lualine/lualine.nvim',

  'nvim-treesitter/nvim-treesitter',
  'nvim-treesitter/nvim-treesitter-refactor',

  -- Colorschemes
  'bluz71/vim-nightfly-guicolors',
  'bluz71/vim-moonfly-colors',
  'fnune/base16-vim',
}

local pluginManager = {
  git = 'https://github.com/savq/paq-nvim.git',
  installDir = string.format('%s/site/pack/paq/opt/paq-nvim', _G.User.config.dataDir),
  isFirstTime = false,

  -- Options to pass to the plugin manager
  config = {
    path = string.format('%s/site/pack/paq/', _G.User.config.dataDir),
  },
}

-- Install plugin manager if not installed, only for new machine
-- or first time load
if vim.fn.isdirectory(pluginManager.installDir) == 0 then
  vim.fn.system({ 'git', 'clone', '--depth', '1', pluginManager.git, pluginManager.installDir })
  pluginManager.isFirstTime = true
end

vim.cmd('packadd paq-nvim')
local paq = require('paq')

paq:setup(pluginManager.config)(plugins)

-- On the first run, install all plugins and then exit
if pluginManager.isFirstTime then
  vim.api.nvim_create_autocmd('User PaqDoneInstall', { command = 'quitall' })
  paq.install()
end

-- =============================================================================
-- = Plugin Post-Config - after loading plugins (POST) =
-- =============================================================================

require('user.plugins')

-- =============================================================================
-- = UI/Theme =
-- =============================================================================

-- moonfly Config
-- ---
vim.g.moonflyNormalFloat = 1

pcall(vim.cmd, 'colorscheme base16-horizon-terminal-dark')
