
-- Diagnostics list view presenting compile warnings in a neat layout.
-- Aggregates workspace diagnostics, LSP references, and list filters.
-- Prompts navigation via split panes with quick jump functionalities.

return {
	"folke/trouble.nvim",
	cmd = { "Trouble" },
	opts = {
		modes = {
			lsp = {
				win = { position = "right" },
			},
		},
	},
}
