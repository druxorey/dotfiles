call plug#begin('~/.config/nvim/plugins/installed')
	" general
	Plug 'sheerun/vim-polyglot'
	Plug 'jiangmiao/auto-pairs'
	Plug 'folke/trouble.nvim'
	Plug 'kylechui/nvim-surround'
	Plug 'nvim-treesitter/nvim-treesitter', { 'as': 'TSUpdate'}
	" telescope
	Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-lua/plenary.nvim'
	" alpha-nvim
    Plug 'goolord/alpha-nvim'
    Plug 'nvim-tree/nvim-web-devicons'
	" lsp
	Plug 'neovim/nvim-lspconfig'
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-buffer'
	Plug 'hrsh7th/cmp-path'
	Plug 'hrsh7th/cmp-cmdline'
	Plug 'hrsh7th/nvim-cmp'
	" themes and appearance
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'dracula/vim', { 'as': 'dracula' }
call plug#end()

luafile ~/.config/nvim/config.lua

