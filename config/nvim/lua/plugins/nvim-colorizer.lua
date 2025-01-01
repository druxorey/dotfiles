return {
	"norcalli/nvim-colorizer.lua",
	dependencies = {},
	event = "VeryLazy",
	opts = {
		-- The filetypes that should be colorized
		'*';
		-- The plugin will not load in these filetypes
		'!vim';
		html = { names = false; }
	},
	config = function()
		require("colorizer").setup()
	end
}
