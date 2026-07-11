return {
	-- Treesitter AST parsers compilation and highlight library.
	-- Parses files into abstract syntax trees for modern code analysis.
	-- Powers smart folds, semantic colorings, and quick code navigation.
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile", "VeryLazy" },
		lazy = vim.fn.argc(-1) == 0, -- load late if no file args
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		opts = {
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"css",
				"go",
				"gomod",
				"gowork",
				"html",
				"javascript",
				"json",
				"latex",
				"less",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"rasi",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"yaml",
				"rust",
			},
		},
		config = function(_, opts)
			require("nvim-treesitter").setup(opts)
		end,
	},

	-- Treesitter extra text objects syntax parser mappings extension.
	-- Adds the ability to manipulate code structures like functions or classes.
	-- Enables selection, swap, and jump functions based on language AST nodes.
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		lazy = true,
	},

	-- Context comments resolving utility powered by Treesitter.
	-- Dynamically sets commentstring values inside mixed-language files.
	-- Essential for correct commenting behaviors inside JSX, HTML, and Vue.
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = {
			enable_autocmd = false,
		},
	},
}
