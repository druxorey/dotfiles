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
				path = "$HOME/Documents/A1 Obsidian",
			}
		},
		disable_frontmatter = true,
	},
}
