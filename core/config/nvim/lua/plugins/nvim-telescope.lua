
-- Telescope fuzzy finder library for scanning files and symbols.
-- Features visual prompt interfaces and layout configurations.
-- Extensible via multiple local search extensions and custom filters.

return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		defaults = {
			layout_strategy = "horizontal",
			layout_config = {
				prompt_position = "top"
			},
			sorting_strategy = "ascending",
			winblend = 0
		}
	},
	config = function(_, opts)
		require("telescope").setup(opts)
	end,
}
