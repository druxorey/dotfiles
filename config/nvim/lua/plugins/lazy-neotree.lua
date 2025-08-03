return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim"
	},
	keys = {
		{ "<leader>E", false },
		{ "<leader>e", false },
	},
	opts = {
		window = {
			position = "right",
			width = 30,
			mapping_options = {
				noremap = true,
				nowait = true
			},
			mappings = {
				["P"] = {
					"toggle_preview",
					config = {
						use_float = false,
					},
				},
			}
		}
	}
}
