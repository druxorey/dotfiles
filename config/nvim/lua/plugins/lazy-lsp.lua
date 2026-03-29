return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			bashls = {
				settings = {
					bashIde = {
						shellcheckArguments = "--exclude=SC2155,SC2086,SC2181",
					},
				},
			},
		},
	},
}
