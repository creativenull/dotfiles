local M = {}

-- Plugin list
-- @param table packager
-- @return table
function M.setup(packager)
    packager.add('kristijanhusak/vim-packager', { type = 'opt' })

    -- Dependencies
    packager.add('Shougo/context_filetype.vim')
    packager.add('kyazdani42/nvim-web-devicons')
    packager.add('nvim-lua/plenary.nvim')
    packager.add('nvim-lua/popup.nvim')

    -- Editor Core
    packager.add('cohama/lexima.vim')
    packager.add('creativenull/projectcmd.nvim')
    packager.add('editorconfig/editorconfig-vim')
    packager.add('godlygeek/tabular')
    packager.add('kevinhwang91/nvim-bqf')
    packager.add('mattn/emmet-vim')
    packager.add('mcchrish/nnn.vim')
    packager.add('tpope/vim-abolish')
    packager.add('tpope/vim-surround')
    packager.add('tyru/caw.vim')

    -- Autocompletion
    packager.add('hrsh7th/nvim-compe')

    -- Snippets
    packager.add('SirVer/ultisnips')
    packager.add('honza/vim-snippets')

    -- Fuzzy finder
    packager.add('nvim-telescope/telescope.nvim')

    -- Git
    packager.add('tpope/vim-fugitive')
    packager.add('lewis6991/gitsigns.nvim')
    packager.add('itchyny/vim-gitbranch')

    -- LSP
    packager.add('neovim/nvim-lspconfig')
    packager.add('glepnir/lspsaga.nvim')
    packager.add('creativenull/diagnosticls-nvim')

    -- UI
    packager.add('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
    packager.add('lukas-reineke/indent-blankline.nvim')
    packager.add('akinsho/nvim-bufferline.lua')
    packager.add('folke/todo-comments.nvim')
    packager.add('norcalli/nvim-colorizer.lua')

    -- Colorscheme
    packager.add('folke/tokyonight.nvim')
    packager.add('glepnir/zephyr-nvim')
end

return M
