return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim"
	},
	opts = {
		window = {
			position = "float",
			width = 30,
			mapping_options = {
				noremap = true,
				nowait = true
			},
			mappings = {
				["P"] = {
					"toggle_preview",
					config = {
						use_float = true,
					},
				},
			}
		},
		filesystem = {
			window = {
				popup = {
					position = { col = "100%", row = "2" },
					size = {
						width = 40,
						height = vim.o.lines - 4
					}
				}
			}
		}

	}
}
