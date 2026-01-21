return {
	"hrsh7th/nvim-cmp",
	dependencies = { "hrsh7th/cmp-emoji" },
	opts = function(_, opts)
		local cmp = require("cmp")

		opts.mapping = vim.tbl_extend("force", opts.mapping, {
			["<CR>"] = cmp.config.disable,
			["<Tab>"] = cmp.mapping.confirm({ select = true }),
		})
	end
}
