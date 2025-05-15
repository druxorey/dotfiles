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
				path = "~/Documents/[01] Obsidian/Academic",
			},
			{
				name = "Workspace",
				path = "~/Documents/[01] Obsidian/Workspace",
			},
		},
		disable_frontmatter = true,
		ui = {
			enable = false,
		},
	},
}
