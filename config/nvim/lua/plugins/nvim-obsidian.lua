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
				name = "Workspace",
				path = "~/Documents/01 Obsidian",
			}
		},
		disable_frontmatter = true,
		ui = {
			enable = false,
		},
	},
}
