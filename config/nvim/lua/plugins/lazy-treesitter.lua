return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		highlight = {
			enable = true,
           	additional_vim_regex_highlighting = false,
		},
		indent = { enable = true },
		ensure_installed = {
			"bash",
			"html",
			"javascript",
			"json",
			"rust",
			"lua",
			"cpp",
			"markdown",
			"markdown_inline",
			"python",
			"rasi",
			"typescript",
			"vim",
		},
	},
}
