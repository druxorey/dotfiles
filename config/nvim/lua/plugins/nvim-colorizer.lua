return {
	"norcalli/nvim-colorizer.lua",
	dependencies = {},
    lazy = false,
	opts = {
		-- The filetypes that should be colorized
		'*';
		-- The plugin will not load in these filetypes
		html = { names = false; }
	},
	config = function()
		require("colorizer").setup()
	end
}
