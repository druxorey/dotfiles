return {
	'MeanderingProgrammer/render-markdown.nvim',
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
		'echasnovski/mini.icons'
	},
	lazy = true,

	config = function()
		require("render-markdown").setup()
	end
}
