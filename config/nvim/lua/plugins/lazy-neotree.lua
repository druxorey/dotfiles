return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim"
	},
	keys = {
		{"<leader>E", false},
	},
	opts = {
		window = {
			position = "left",
			width = 30,
			mapping_options = {
				noremap = true,
				nowait = true
			}
		}
	}
}
