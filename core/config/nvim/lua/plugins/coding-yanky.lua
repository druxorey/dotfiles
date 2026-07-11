
-- Enhanced paste clipboard history and navigation utility.
-- Keeps track of multiple copied segments for quick recall.
-- Adds handy cursor indentation and visual cycle paste behaviors.

return {
	"gbprod/yanky.nvim",
	event = "VeryLazy",
	opts = {
		highlight = {
			on_put = true,
			on_yank = true,
			timer = 150,
		},
	},
	config = function(_, opts)
		require("yanky").setup(opts)
		local colors = require("core.colorscheme")
		vim.api.nvim_set_hl(0, "YankyYanked", { bg = colors.drx_color_pink_2, fg = colors.drx_color_text })
		vim.api.nvim_set_hl(0, "YankyPutted", { bg = colors.drx_color_green_2, fg = colors.drx_color_text })
	end,
}

