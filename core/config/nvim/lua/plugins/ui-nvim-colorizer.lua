
-- Color highlighter parsing hex codes inside files automatically.
-- Renders matching backgrounds directly behind CSS/HTML color strings.
-- Optimized for speed and low CPU utilization across all buffers.

return  {
	"catgoose/nvim-colorizer.lua",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		'*';
		html = { names = false; }
	},
	config = function(_, opts)
		require("colorizer").setup(opts)
	end
}
