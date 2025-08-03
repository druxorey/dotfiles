return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	keys = {
		-- Disabling the default keymaps set by lazyvim
		{ "<leader><space>", mode = { "n" }, false },
		{ "<leader>ff", mode = { "n" }, false },
		{ "<leader>fF", mode = { "n" }, false },
		{ "<leader>fg", mode = { "n" }, false },
		{ "<leader>fb", mode = { "n" }, false },
		{ "<leader>fh", mode = { "n" }, false },
	}
}
