
-- Markdown previewer enhancement rendering styled titles and code blocks.
-- Generates visual table structures, blockquotes, and text decoration.
-- Enables neat documentation previews directly inside active buffers.

return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
}
