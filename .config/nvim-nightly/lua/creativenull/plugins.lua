vim.cmd 'packadd packer.nvim'
local packer = require('packer')

packer.init({
    package_root = '~/.local/share/nvim-nightly/site/pack',
    compile_path = '~/.config/nvim-nightly/plugin/packer_compiled.vim'
})

return packer.startup(function()
    use { 'wbthomason/packer.nvim', opt = true }

    -- Editor
    use 'tpope/vim-surround'
    use 'SirVer/ultisnips'
    use 'Shougo/context_filetype.vim'
    use 'tyru/caw.vim'
    use 'lewis6991/gitsigns.nvim'

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/completion-nvim'
    use 'nvim-lua/lsp-status.nvim'
    use { 'nvim-telescope/telescope.nvim', requires = {
        { 'nvim-lua/popup.nvim' },
        { 'nvim-lua/plenary.nvim' }
    } }

    -- Themes and Syntax
    use 'gruvbox-community/gruvbox'
    use 'yggdroot/indentline'
    use 'nvim-treesitter/nvim-treesitter'
end)
