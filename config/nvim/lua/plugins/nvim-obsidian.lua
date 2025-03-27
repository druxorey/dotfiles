return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "Academic",
				path = "~/Documents/Obsidian/Academic",
			},
			{
				name = "Workspace",
				path = "~/Documents/Obsidian/Workspace",
			},
		},
		disable_frontmatter = true,
		ui = {
			enable = false,
		},
	},
}
