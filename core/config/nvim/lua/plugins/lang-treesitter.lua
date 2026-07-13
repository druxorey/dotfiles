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
				"typescript",
				"yaml",
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

	-- Treesitter-based code splitting and joining utility. Allows to toggle code
	-- blocks between one-line and multi-line formats. Uses AST nodes to
	-- intelligently restructure function calls, objects, and arrays.
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup({
				use_default_keymaps = false,
			})
		end,
	},

	-- HTML auto tags renaming and closing utility using Treesitter.
	-- Automatically closes tags as you type and updates matching elements.
	-- Supports XML, JSX, TSX, HTML, and other markup syntax nodes.
	{
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
		opts = {},
	},

	-- Improves comment syntax, lets Neovim handle multiple
	-- types of comments for a single language, and relaxes rules
	-- for uncommenting.
	{
		"folke/ts-comments.nvim",
		event = "VeryLazy",
		opts = {},
	},
}
