local packer = require('packer')

packer.init({
    package_root = '~/.local/share/nvim-nightly/site/pack',
    compile_path = '~/.config/nvim-nightly/plugin/packer_compiled.vim'
})

return packer.startup(function()
    use { 'wbthomason/packer.nvim', opt = true }

    -- Editor
    use 'jiangmiao/auto-pairs'
    use 'tpope/vim-surround'
    use 'Shougo/context_filetype.vim'
    use 'tyru/caw.vim'
    use 'SirVer/ultisnips'
    use { 'lewis6991/gitsigns.nvim', opt = true }
    -- use { 'creativenull/projectcmd.nvim', opt = true }

    -- LSP
    use { 'neovim/nvim-lspconfig', opt = true  }
    use { 'nvim-lua/completion-nvim', opt = true  }
    use { 'nvim-lua/lsp-status.nvim', opt = true  }
    use { 'nvim-telescope/telescope.nvim', opt = true,
        requires = {
            { 'nvim-lua/popup.nvim', opt = true },
            { 'nvim-lua/plenary.nvim', opt = true }
        }
    }

    -- Themes and Syntax
    use 'gruvbox-community/gruvbox'
    use 'yggdroot/indentline'
    use { 'nvim-treesitter/nvim-treesitter', opt = true }
end)
