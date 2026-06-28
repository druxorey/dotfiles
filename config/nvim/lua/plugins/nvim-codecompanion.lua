return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		{ "stevearc/dressing.nvim", opts = {} },
	},
	opts = {
		language = "Spanish",
		interactions = {
			chat = {
				adapter = {
					name = "gemini",
					model = "gemini-2.5-flash",
				},
			},
		},
	},
}
