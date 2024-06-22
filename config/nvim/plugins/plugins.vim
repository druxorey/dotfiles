call plug#begin('~/.config/nvim/plugins/installed')

	" UI Plugins
	Plug 'goolord/alpha-nvim'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'dracula/vim', { 'as': 'dracula' }
	Plug 'lukas-reineke/indent-blankline.nvim'
	Plug 'nvim-tree/nvim-tree.lua', { 'on': 'NvimTreeToggle' }
	Plug 'nvim-tree/nvim-web-devicons'
	Plug 'norcalli/nvim-colorizer.lua'

	" Language Support and Syntax Highlighting Plugins
	Plug 'sheerun/vim-polyglot'
	Plug 'nvim-treesitter/nvim-treesitter', { 'as': 'TSUpdate'}
	Plug 'neovim/nvim-lspconfig'
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-buffer'
	Plug 'hrsh7th/cmp-path'
	Plug 'hrsh7th/cmp-cmdline'
	Plug 'hrsh7th/nvim-cmp'

	" Utility Plugins
	Plug 'michaelrommel/nvim-silicon', { 'on': 'Silicon' }
	Plug 'github/copilot.vim'
	Plug 'jiangmiao/auto-pairs'
	Plug 'kylechui/nvim-surround'
	Plug 'folke/trouble.nvim', { 'on': 'TroubleToggle' }
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-lua/plenary.nvim'

	" Mason Plugins
	Plug 'williamboman/mason.nvim'
	Plug 'williamboman/mason-lspconfig.nvim'
	Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'

	" Git Plugins
	Plug 'tpope/vim-fugitive'

call plug#end()

for luafile in glob("~/.config/nvim/config/lua/*.lua", v:true, v:true)
    execute 'luafile' luafile
endfor
