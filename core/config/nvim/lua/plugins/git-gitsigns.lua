
-- Git signs integration to highlight added, changed, and deleted lines.
-- Shows status signs in the gutter column of active buffers.
-- Supports hunk stage, undo, preview, and blame inline popups.

return {
	"lewis6991/gitsigns.nvim",
	event = "VeryLazy",
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
	},
}
