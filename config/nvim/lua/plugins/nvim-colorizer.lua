return {
	"norcalli/nvim-colorizer.lua",
	dependencies = {},
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
