
-- Session persistence utility saving active tabs and buffer files.
-- Restores editor state on startup dynamically based on directory roots.
-- Integrates cleanly with lazy.nvim and custom session menus.

return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	opts = {},
}
