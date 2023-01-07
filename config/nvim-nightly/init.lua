-- ============================================================================
-- Your custom user config variables
--
-- This is your custom user config, use this to add variables that you might
-- use in different plugins. Note, this is just an example on how I would
-- structure it, it's up to you to adjust it to your liking.
--
-- Tags: USER
-- ============================================================================

local userspace = 'nvim-nightly'
local config_path = vim.fn.expand(string.format('~/.config/%s', userspace))
local data_path = vim.fn.expand(string.format('~/.local/share/%s', userspace))
local cache_path = vim.fn.expand(string.format('~/.cache/%s', userspace))
local state_path = vim.fn.expand(string.format('~/.local/state/%s', userspace))

local config = {
	userspace = userspace,
	plugin = {
		url = 'https://github.com/folke/lazy.nvim',
		filepath = string.format('%s/lazy/lazy.nvim', data_path),
		config = {
			lockfile = string.format('%s/lazy-lock.json', config_path),
			root = string.format('%s/lazy', data_path),
			performance = {
				cache = {
					path = string.format('%s/lazy/cache', cache_path),
				},
			},
			readme = {
				root = string.format('%s/lazy/readme', state_path),
			},
		},
	},
	undo_dir = string.format('%s/undo', cache_path),
	options = {
		column_limit = '120',
	},
	keymap = {
		leader = ' ',
	},
	autocmd = {
		group = vim.api.nvim_create_augroup('UserCustomGroup', {}),
	},
	treesitter = {
		parser_install_dir = string.format('%s/treesitter', data_path),
		ensure_installed = {
			'go',
			'help',
			'javascript',
			'json',
			'lua',
			'php',
			'tsx',
			'typescript',
			'vim',
		},
		highlight = { enable = true },
		textobjects = {
			select = { enable = true },
		},
	},
	lsp = {
		fmt_on_save = false,
		fmt_opts = { async = false, timeout = 2500 },

		-- Use this to conditionally set a keybind for formatting
		-- code a lsp server defined here. Because some servers do
		-- not have that capability or you would rather exclusively
		-- use null-ls.
		--
		-- NOTE: Null-ls is enabled by default for formatting, so you
		-- don't need to add null-ls here.
		fmt_allowed_servers = {
			'denols',
			'gopls',
		},

		-- For mason.nvim
		servers = {
			'gopls',
			'jsonls',
			'sumneko_lua',
			'tsserver',
			'volar',
			'intelephense',
		},
		tools = {
			'eslint_d',
			'prettier',
			'stylua',
			'php-cs-fixer',
			'phpstan',
			'pint',
		},
	},
}

-- Requirement check
if vim.fn.has 'nvim-0.9' == 0 then
	print 'Neovim >= v0.9 is required for this config'
	return
end

-- ============================================================================
-- Nvim Nightly Setup
--
-- This is required to keep config separate from ~/.config/nvim
--
-- Tags: NIGHTLY
-- ============================================================================

vim.cmd 'set runtimepath-=~/.config/nvim'
vim.cmd 'set runtimepath-=~/.config/nvim/after'
vim.cmd 'set runtimepath-=~/.local/share/nvim/site'
vim.cmd 'set runtimepath-=~/.local/share/nvim/site/after'
vim.cmd 'set runtimepath-=/etc/xdg/nvim'
vim.cmd 'set runtimepath-=/etc/xdg/nvim/after'
vim.cmd 'set runtimepath-=/usr/share/nvim/site'
vim.cmd 'set runtimepath-=/usr/share/nvim/site/after'
vim.cmd 'set runtimepath-=/usr/local/share/nvim/site'
vim.cmd 'set runtimepath-=/usr/local/share/nvim/site/after'

vim.cmd(string.format('set runtimepath+=~/.config/%s/after', config.userspace))
vim.cmd(string.format('set runtimepath^=~/.config/%s', config.userspace))
vim.cmd(string.format('set runtimepath+=~/.local/share/%s/site/after', config.userspace))
vim.cmd(string.format('set runtimepath^=~/.local/share/%s/site', config.userspace))

-- Pack Path
vim.cmd 'set packpath-=~/.config/nvim'
vim.cmd 'set packpath-=~/.config/nvim/after'
vim.cmd 'set packpath-=~/.local/share/nvim/site'
vim.cmd 'set packpath-=~/.local/share/nvim/site/after'
vim.cmd 'set packpath-=/etc/xdg/nvim'
vim.cmd 'set packpath-=/etc/xdg/nvim/after'
vim.cmd 'set packpath-=/usr/local/share/nvim/site'
vim.cmd 'set packpath-=/usr/local/share/nvim/site/after'
vim.cmd 'set packpath-=/usr/share/nvim/site'
vim.cmd 'set packpath-=/usr/share/nvim/site/after'

vim.cmd(string.format('set packpath^=~/.config/%s', config.userspace))
vim.cmd(string.format('set packpath+=~/.config/%s/after', config.userspace))
vim.cmd(string.format('set packpath^=~/.local/share/%s/site', config.userspace))
vim.cmd(string.format('set packpath+=~/.local/share/%s/site/after', config.userspace))

-- ============================================================================
-- Functions
--
-- These are utility functions that is used for convenience, do not remove but
-- you are welcome to add your own functions that can be used anywhere in this
-- file.
--
-- Tags: FUNC
-- ============================================================================

---Ensure that the undo directory is created before we user it.
---@param dir string
---@return nil
local function ensure_undo_dir(dir)
	if vim.fn.isdirectory(dir) == 0 then
		if vim.fn.has 'win32' == 1 then
			vim.fn.system { 'mkdir', '-Recurse', dir }
		else
			vim.fn.system { 'mkdir', '-p', dir }
		end
	end
end

---Reload the config file, this is tightly interoped with lazy.nvim
---@return nil
local function reload_config()
	-- Check if LSP servers are running and terminate, if running
	local attached_clients = vim.lsp.get_active_clients()
	if not vim.tbl_isempty(attached_clients) then
		for _, client in pairs(attached_clients) do
			-- The exception is null-ls as it does not restart after
			-- reloading the init.lua file
			if client.name ~= 'null-ls' then
				vim.lsp.stop_client(client.id)
			end
		end
	end

	vim.api.nvim_command 'source $MYVIMRC'

	-- Install missing plugins
	require('lazy').install()
end

---Register a keymap to format code via LSP
---@param key string The key to trigger formatting, eg "<Leader>p"
---@param name string The LSP client name
---@param bufnr number The buffer handle of LSP client
---@return nil
local function register_lsp_fmt_keymap(key, name, bufnr)
	vim.keymap.set('n', key, function()
		vim.lsp.buf.format(vim.tbl_extend('force', config.lsp.fmt_opts, { name = name, bufnr = bufnr }))
	end, { desc = string.format('Format current buffer [LSP - %s]', name), buffer = bufnr })
end

---Register the write event to format code via LSP
---@param name string The LSP client name
---@param bufnr number The buffer handle of LSP client
---@return nil
local function register_lsp_fmt_autosave(name, bufnr)
	vim.api.nvim_create_autocmd('BufWritePost', {
		group = config.autocmd.group,
		buffer = bufnr,
		callback = function()
			vim.lsp.buf.format(vim.tbl_extend('force', config.lsp.fmt_opts, { name = name, bufnr = bufnr }))
		end,
		desc = string.format('Format on save [LSP - %s]', name),
	})
end

---Generic LSP attached info for statusline, tabline, etc
---@return string
local function attached_lsp_clients()
	local clients = vim.lsp.get_active_clients()

	if vim.tbl_isempty(clients) then
		return ''
	end

	-- We only want unique names from attached clients
	local unique_client_names = {}
	for _, client in pairs(clients) do
		local name = ' ' .. client.name
		if name == 'null-ls' then
			name = ' ' .. client.name
		end

		unique_client_names[name] = true
	end

	return table.concat(vim.tbl_keys(unique_client_names), ', ')
end

-- ============================================================================
-- Events
--
-- Add your specific events/autocmds in here, but you are free to add then
-- anywhere you like. Example, show a highlight when yanking text:
--
--      vim.api.nvim_create_autocmd('TextYankPost', {
--      	group = config.autocmd.group,
--      	callback = function()
--      		vim.highlight.on_yank { higroup = 'IncSearch', timeout = 300 }
--      	end,
--      	desc = 'Show a highlight on yank',
--      })
--
-- Tags: EVENTS
-- ============================================================================

-- From vim defaults.vim
-- ---
-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).
vim.api.nvim_create_autocmd('BufReadPost', {
	group = config.autocmd.group,
	callback = function(args)
		local valid_line = vim.fn.line [['"]] >= 1 and vim.fn.line [['"]] < vim.fn.line '$'
		local not_commit = vim.b[args.buf].filetype ~= 'commit'

		if valid_line and not_commit then
			vim.cmd [[normal! g`"]]
		end
	end,
	desc = 'Go the to last known position when opening a new buffer',
})

-- Show a highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
	group = config.autocmd.group,
	callback = function()
		vim.highlight.on_yank { higroup = 'IncSearch', timeout = 300 }
	end,
	desc = 'Show a highlight on yank',
})

-- Reload config and lazy.nvim sync on saving the init.lua file
vim.api.nvim_create_autocmd('BufWritePost', {
	group = config.autocmd.group,
	pattern = string.format('%s/init.lua', vim.fn.stdpath 'config'),
	callback = reload_config,
	desc = 'Reload config file and lazy.nvim sync',
})

-- ============================================================================
-- File Type Configurations
--
-- Add any file type changes you want to do. This works in the same way you
-- would add your configurations in a ftdetect/<filetype>.lua or in
-- ftplugin/<filetype>.lua
--
-- For most cases, you will use vim.filetype.add() to make your adjustments.
-- Check `:help vim.filetype.add` for more documentation and
-- `:edit $VIMRUNTIME/lua/vim/filetype.lua` for examples.
--
-- Tags: FILETYPE
-- ============================================================================

vim.filetype.add {
	extension = {
		js = 'javascriptreact',
		podspec = 'ruby',
		mdx = 'markdown',
	},
	filename = {
		Podfile = 'ruby',
	},
}

-- ============================================================================
-- Vim Options
--
-- Add your custom vim options with `vim.opt`. Example, show number line and
-- sign column:
--
-- vim.opt.number = true
-- vim.opt.signcolumn = 'yes'
--
-- Tags: OPT
-- ============================================================================

ensure_undo_dir(config.undo_dir)

-- Completion
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.shortmess:append 'c'

-- Search
vim.opt.showmatch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.path = { '**' }
vim.opt.wildignore = { '*.git/*', '*node_modules/*', '*vendor/*', '*dist/*', '*build/*' }

-- Editor
vim.opt.colorcolumn = { config.options.column_limit }
vim.opt.expandtab = true
vim.opt.lazyredraw = true
vim.opt.foldenable = false
vim.opt.spell = false
vim.opt.wrap = false
vim.opt.scrolloff = 1
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.wildignorecase = true

-- System
vim.opt.undodir = config.undo_dir
vim.opt.history = 10000
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 500

-- UI
vim.opt.cmdheight = 2
vim.opt.number = true
vim.opt.showtabline = 0
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.opt.laststatus = 3
vim.opt.fillchars:append { eob = ' ' }

-- =============================================================================
-- Keymaps
--
-- Add your custom keymaps with `vim.keymap.set()`. Example, Use jk to go from
-- insert to normal mode:
--
-- vim.keymap.set('i', 'jk', '<Esc>')
--
-- Tags: KEY
-- =============================================================================

vim.g.mapleader = config.keymap.leader

-- Unbind default bindings for arrow keys, trust me this is for your own good
vim.keymap.set('', '<Up>', '')
vim.keymap.set('', '<Down>', '')
vim.keymap.set('', '<Left>', '')
vim.keymap.set('', '<Right>', '')
vim.keymap.set('i', '<Up>', '')
vim.keymap.set('i', '<Down>', '')
vim.keymap.set('i', '<Left>', '')
vim.keymap.set('i', '<Right>', '')

-- Resize window panes, we can use those arrow keys
-- to help use resize windows - at least we give them some purpose
vim.keymap.set('n', '<Up>', '<Cmd>resize +2<CR>')
vim.keymap.set('n', '<Down>', '<Cmd>resize -2<CR>')
vim.keymap.set('n', '<Left>', '<Cmd>vertical resize -2<CR>')
vim.keymap.set('n', '<Right>', '<Cmd>vertical resize +2<CR>')

-- Map Esc, to perform quick switching between Normal and Insert mode
vim.keymap.set('i', 'jk', '<Esc>')

-- Map escape from terminal input to Normal mode
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])
vim.keymap.set('t', '<C-[>', [[<C-\><C-n>]])

-- Disable highlights
vim.keymap.set('n', '<Leader><CR>', '<Cmd>noh<CR>', { desc = 'Disable search highlight' })

-- Edit vimrc
vim.keymap.set('n', '<Leader>ve', '<Cmd>edit $MYVIMRC<CR>', { desc = 'Open init.lua' })

-- Source the vimrc to reflect changes
vim.keymap.set('n', '<Leader>vs', '<Cmd>ConfigReload<CR>', { desc = 'Reload init.lua' })

-- Reload file
vim.keymap.set('n', '<Leader>r', '<Cmd>edit!<CR>', { desc = 'Reload current buffer with the file' })

-- Copy/Paste from sytem clipboard
vim.keymap.set('v', 'p', [["_dP]], { desc = 'Paste from yanked contents only' })
vim.keymap.set('v', '<Leader>y', [["+y]], { desc = 'Yank from system clipboard' })
vim.keymap.set('n', '<Leader>y', [["+y]], { desc = 'Yank from system clipboard' })
vim.keymap.set('n', '<Leader>p', [["+p]], { desc = 'Paste from system clipboard' })

-- =============================================================================
-- User Commands
--
-- You custom user commands with `vim.api.nvim_create_user_command()`, you can
-- set any commands you like or even abbreviations (which gets quite helpful
-- when making mistakes).
--
-- Tags: CMD
-- =============================================================================

vim.api.nvim_create_user_command('Config', 'edit $MYVIMRC', { desc = 'Open config' })
vim.api.nvim_create_user_command('ConfigReload', reload_config, { desc = 'Reload config' })

-- Command Abbreviations, I can't release my shift key fast enough :')
vim.cmd 'cnoreabbrev Q  q'
vim.cmd 'cnoreabbrev Qa qa'
vim.cmd 'cnoreabbrev W  w'
vim.cmd 'cnoreabbrev Wq wq'

vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })

-- ============================================================================
-- Plugins
--
-- Add your plugins in here along with their configurations. However, the
-- exception is for LSP configurations which is done separately further below.
--
-- A quick guide on how to install plugins with lazy.nvim:
--
--     + Visit any vim plugin repository on GitHub (or GitLab, etc)
--
--     + Copy the first and second path of the URL:
--         For example, if `https://github.com/bluz71/vim-moonfly-colors`
--         then just copy `bluz71/vim-moonfly-colors`
--
--         If you are using GitLab or any other git server, then you will have to
--         copy the entire URL and
--         not just the last two paths of the URL.
--
--     + Add what you copied into a table/string
--
--     + If you have to pass options to the plug, then use a table instead
--         Example, for `windwp/nvim-autopairs` you need to run the installer
--         so call with:
--             {
--                 "windwp/nvim-autopairs",
--             	   config = function()
--                     require("nvim-autopairs").setup({})
--             	   end,
--             }
--
-- Tags: PLUG
-- ============================================================================

local lazypath = config.plugin.filepath
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'--single-branch',
		config.plugin.url,
		lazypath,
	}
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup({
	-- Add your plugins inside this function
	-- ---

	-- Example:
	--
	-- {
	-- 	'folke/which-key.nvim',
	-- 	config = function()
	-- 		require('which-key').setup {
	-- 			triggers = { '<Leader>' },
	-- 			window = {
	-- 				border = 'rounded',
	-- 			},
	-- 		}
	-- 	end,

	{
		'folke/which-key.nvim',
		config = {
			triggers = { '<Leader>' },
			window = { border = 'rounded' },
		},
	},

	{
		'editorconfig/editorconfig-vim',
		init = function()
			vim.g.user_emmet_leader_key = '<C-q>'
			vim.g.user_emmet_mode = 'i'
		end,
	},

	{
		'mattn/emmet-vim',
		config = function()
			vim.g.user_emmet_leader_key = '<C-q>'
		end,
	},

	{
		'kylechui/nvim-surround',
		config = function()
			require('nvim-surround').setup {}
		end,
	},

	{
		'windwp/nvim-autopairs',
		config = function()
			require('nvim-autopairs').setup {}
		end,
	},

	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end,
	},

	{
		'vim-ctrlspace/vim-ctrlspace',
		init = function()
			vim.g.CtrlSpaceDefaultMappingKey = '<C-space> '
			vim.g.CtrlSpaceSymbols = { File = '', Tabs = '', BM = '' }
			vim.g.CtrlSpaceSaveWorkspaceOnExit = 1
		end,
	},

	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		keys = {
			{ '<C-p>', '<Cmd>Telescope find_files<CR>', desc = 'Open file finder (telescope)' },
			{ '<C-t>', '<Cmd>Telescope live_grep<CR>', desc = 'Open text search (telescope)' },
		},
	},

	-- Treesitter
	--
	-- Tag: TREE
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
		build = function()
			require('nvim-treesitter.install').update { with_sync = true }()
		end,
		config = function()
			vim.opt.runtimepath:append(config.treesitter.parser_install_dir)
			require('nvim-treesitter.configs').setup(config.treesitter)
		end,
	},

	-- LSP + Tools + Debug
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Linter/Formatter
			'jose-elias-alvarez/null-ls.nvim',
			-- Tool installer
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			'WhoIsSethDaniel/mason-tool-installer.nvim',
			-- UI/Aesthetics
			'glepnir/lspsaga.nvim',
			'j-hui/fidget.nvim',
			-- Completion
			'hrsh7th/cmp-nvim-lsp',
		},
	},

	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			-- Cmdline completions
			'hrsh7th/cmp-cmdline',
			-- Path completions
			'hrsh7th/cmp-path',
			-- Buffer completions
			'hrsh7th/cmp-buffer',
			-- LSP completions
			'hrsh7th/cmp-nvim-lsp',
			'onsails/lspkind-nvim',
			-- vnsip completions
			'saadparwaiz1/cmp_luasnip',
			'L3MON4D3/LuaSnip',
			'rafamadriz/friendly-snippets',
		},
		event = { 'InsertEnter', 'CmdlineEnter' },
		config = function()
			-- Luasnip
			require('luasnip.loaders.from_vscode').lazy_load()
			local luasnip = require 'luasnip'

			-- Cmp
			local cmp = require 'cmp'

			vim.g.vsnip_filetypes = {
				javascriptreact = { 'javascript' },
				typescriptreact = { 'typescript' },
			}

			local function has_words_before()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
			end

			cmp.setup {
				completion = {
					keyword_length = 2,
				},

				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},

				mapping = {
					['<C-Space>'] = cmp.mapping.complete {},
					['<C-y>'] = cmp.mapping.confirm { select = true },
					['<C-n>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
						end
					end, { 'i', 's' }),

					['<C-p>'] = cmp.mapping(function()
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { 'i', 's' }),
				},

				sources = cmp.config.sources({
					{ name = 'nvim_lsp', max_item_count = 10 },
					{ name = 'luasnip', max_item_count = 5 },
				}, {
					{ name = 'buffer', max_item_count = 5 },
					{ name = 'path', max_item_count = 5 },
				}),

				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered 'rounded',
				},

				formatting = {
					format = require('lspkind').cmp_format {
						mode = 'symbol_text',
						menu = {
							buffer = '[BUF]',
							nvim_lsp = '[LSP]',
							luasnip = '[SNP]',
							path = '[PTH]',
						},
					},
				},
			}

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ '/', '?' }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'buffer' },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = 'path' },
				}, {
					{ name = 'cmdline' },
				}),
			})
		end,
	},

	{
		'feline-nvim/feline.nvim',
		config = function()
			require('feline').setup()
		end,
	},

	{
		'lukas-reineke/indent-blankline.nvim',
		config = function()
			vim.g.indent_blankline_show_first_indent_level = false
		end,
	},

	{
		'folke/todo-comments.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('todo-comments').setup {}
		end,
	},

	{
		'lewis6991/gitsigns.nvim',
		branch = 'release',
		config = function()
			require('gitsigns').setup()
		end,
	},

	-- Colorschemes
	{
		'bluz71/vim-moonfly-colors',
		lazy = true,
		init = function()
			vim.g.moonflyNormalFloat = true
			vim.g.moonflyWinSeparator = 2
		end,
	},
}, config.plugin.config)

-- ============================================================================
-- LSP Configuration
--
-- LSP Server configurations goes here. This is also where you should add any
-- logic that concerns the builtin LSP client.
--
-- For example:
--  + You need LSP servers installed? Add mason config here
--  + You need to add some UI/change look of your LSP/Statusline/Tabline/Winbar
--    etc but is tightly integrated with LSP? Add them here
--
-- Tags: LSPCONFIG
-- ============================================================================

-- fidget.nvim Config
-- ---
require('fidget').setup {
	fmt = {
		-- function to format fidget title
		fidget = function(fidget_name, spinner)
			return string.format(' %s %s ', spinner, fidget_name)
		end,
		-- function to format each task line
		task = function(task_name, message, percentage)
			return string.format(' %s%s [%s] ', message, percentage and string.format(' (%s%%)', percentage) or '', task_name)
		end,
	},
}

-- LSP Saga Config
-- ---
require('lspsaga').init_lsp_saga { border_style = 'rounded' }

-- mason.nvim Config
-- ---
require('mason').setup()
require('mason-tool-installer').setup {
	ensure_installed = config.lsp.tools,
	automatic_installation = true,
}
require('mason-lspconfig').setup {
	ensure_installed = config.lsp.servers,
	automatic_installation = true,
}

-- nvim-lspconfig Config
-- ---
local lspconfig = require 'lspconfig'

local float_opts = {
	border = 'rounded',
	width = 80,
}

-- Global diagnostic config
vim.diagnostic.config {
	update_in_insert = false,
	float = {
		source = true,
		border = float_opts.border,
		width = float_opts.width,
	},
}

-- Window options
require('lspconfig.ui.windows').default_options.border = float_opts.border

-- Hover options
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, float_opts)

-- Signature help options
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = float_opts.border,
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local function on_attach(client, bufnr)
	-- Omnifunc backup
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- LSP Keymaps
	vim.keymap.set('n', '<Leader>la', '<Cmd>Lspsaga code_action<CR>', { desc = 'LSP Code Actions', buffer = bufnr })
	vim.keymap.set('n', '<Leader>ld', vim.lsp.buf.definition, { desc = 'LSP Go-to Definition', buffer = bufnr })
	vim.keymap.set('n', '<Leader>lh', '<Cmd>Lspsaga hover_doc<CR>', { desc = 'LSP Hover Information', buffer = bufnr })
	vim.keymap.set('n', '<Leader>lr', '<Cmd>Lspsaga rename<CR>', { desc = 'LSP Rename', buffer = bufnr })
	vim.keymap.set('n', '<Leader>ls', vim.lsp.buf.signature_help, { desc = 'LSP Signature Help', buffer = bufnr })
	vim.keymap.set('n', '<Leader>le', vim.diagnostic.setloclist, { desc = 'LSP Show All Diagnostics', buffer = bufnr })
	vim.keymap.set('n', '<Leader>lw', function()
		vim.diagnostic.open_float { bufnr = bufnr, scope = 'line' }
	end, { desc = 'Show LSP Line Diagnostic', buffer = bufnr })

	if
		vim.tbl_contains(config.lsp.fmt_allowed_servers, client.name)
		and client.server_capabilities.documentFormattingProvider
	then
		register_lsp_fmt_keymap('<Leader>lf', client.name, bufnr)

		if config.lsp.fmt_on_save then
			register_lsp_fmt_autosave(client.name, bufnr)
		end
	end
end

local lspconfig_setup_defaults = {
	capabilities = capabilities,
	on_attach = on_attach,
}

-- Lua
local lua_rtp = vim.split(package.path, ';')
table.insert(lua_rtp, 'lua/?.lua')
table.insert(lua_rtp, 'lua/?/init.lua')
lspconfig.sumneko_lua.setup(vim.tbl_extend('force', lspconfig_setup_defaults, {
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
				path = lua_rtp,
			},
			diagnostics = { globals = { 'vim' } },
			workspace = {
				library = vim.api.nvim_get_runtime_file('', true),
				checkThirdParty = false,
			},
			telemetry = { enable = false },
		},
	},
}))

-- Web Development
-- ---
-- We only want to attach to a node/frontend project if it matches
-- package.json, jsconfig.json or tsconfig.json file
local lspconfig_node_options = {
	root_dir = require('lspconfig.util').root_pattern { 'package.json', 'jsconfig.json', 'tsconfig.json' },
}

lspconfig.tsserver.setup(vim.tbl_extend('force', lspconfig_setup_defaults, lspconfig_node_options))
lspconfig.jsonls.setup(vim.tbl_extend('force', lspconfig_setup_defaults, lspconfig_node_options))
lspconfig.volar.setup(vim.tbl_extend('force', lspconfig_setup_defaults, {
	-- Take over mode
	filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
	root_dir = require('lspconfig.util').root_pattern { 'vite.config.js', 'vite.config.ts' },
	init_options = {
		typescript = {
			tsdk = string.format('%s/node_modules/typescript/lib', vim.fn.getcwd()),
		},
	},
}))

local lspconfig_deno_options = { root_dir = require('lspconfig.util').root_pattern { 'deno.json', 'deno.jsonc' } }
lspconfig.denols.setup(vim.tbl_extend('force', lspconfig_setup_defaults, lspconfig_deno_options))

lspconfig.intelephense.setup(lspconfig_setup_defaults)

-- Go development
-- ---
lspconfig.gopls.setup(lspconfig_setup_defaults)

-- Null-ls Config
-- ---
local nls_node_options = {
	condition = function(utils)
		return utils.root_has_file { 'package.json', 'tsconfig.json', 'jsconfig.json' }
	end,
}

local nls_phpcsfixer_options = {
	condition = function(utils)
		return utils.root_has_file { '.php-cs-fixer.php' }
	end,
}

local nls_pint_options = {
	condition = function(utils)
		return utils.root_has_file { 'pint.json' }
	end,
}

local nls = require 'null-ls'
nls.setup {
	sources = {
		-- We only want to have eslint and prettier to run when it matches_error
		-- a root file
		-- nls.builtins.diagnostics.eslint_d.with(nls_node_options),
		nls.builtins.formatting.prettier.with(nls_node_options),

        -- php
		nls.builtins.diagnostics.phpstan,
		nls.builtins.formatting.phpcsfixer.with(nls_phpcsfixer_options),
		nls.builtins.formatting.pint.with(nls_pint_options),

		-- Custom stylua just for this init.lua file
		nls.builtins.formatting.stylua.with {
			extra_args = {
				'--column-width',
				config.options.column_limit,
				'--line-endings',
				'Unix',
				'--indent-width',
				'2',
				'--quote-style',
				'AutoPreferSingle',
				'--call-parentheses',
				'None',
			},
		},
	},
	on_attach = function(client, bufnr)
		register_lsp_fmt_keymap('<Leader>lf', client.name, bufnr)

		if config.lsp.fmt_on_save then
			register_lsp_fmt_autosave(client.name, bufnr)
		end
	end,
}

-- ============================================================================
-- Theme
--
-- Colorscheme and their configuration comes last.
--
-- If you want to change some highlights that is separate to the ones provided
-- by another colorscheme, then you will have to add these changes within the
-- ColorScheme autocmd.
--
-- Example, to change WinSeparator highlight:
--
--      vim.api.nvim_create_autocmd('ColorScheme', {
--      	group = config.autocmd.group,
--      	callback = function()
--      		vim.api.nvim_set_hl(0, 'WinSeparator', { bg = 'NONE', fg = '#eeeeee' })
--      	end,
--      })
--
--
-- NOTE: if a colorscheme already has a lua setup() that helps you change
-- highlights to your desired colors then use that instead of creating a
-- ColorScheme autocmd. Only use autocmd when it's not supported.
--
-- Tags: THEME, COLOR, COLORSCHEME
-- ============================================================================

pcall(function()
	vim.cmd 'colorscheme moonfly'
end)
