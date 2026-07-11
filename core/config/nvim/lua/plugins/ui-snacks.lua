
-- General Neovim utility enhancements library providing minor tools.
-- Optimizes big files loading, statuscolumns, notifications, and animations.
-- Replaces individual tiny plugins with high performance visual utilities.

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		bufdelete = { enabled = true },
		notifier = { enabled = true, timeout = 3000 },
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		indent = { enabled = true },
		scroll = { enabled = false },
	},
}
