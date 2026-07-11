
-- Highlight and search TODO comments with customizable color tags.
-- Automatically parses patterns like TODO, FIX, WARNING, or NOTE.
-- Links to Telescope, Trouble, or quickfix lists for easy project search.

return {
	"folke/todo-comments.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {},
}
