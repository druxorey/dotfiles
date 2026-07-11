
-- Markdown previewer enhancement rendering styled titles and code blocks.
-- Generates visual table structures, blockquotes, and text decoration.
-- Enables neat documentation previews directly inside active buffers.

return {
	"OXY2DEV/markview.nvim",
	ft = { "markdown" },
	config = function()
		require("markview").setup()
	end
}
