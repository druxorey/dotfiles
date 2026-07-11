--
-- VimTeX plugin providing modern writing support for LaTeX documents.
-- Features compilation methods, viewer configurations, and forward search.
-- Includes syntax highlights, folds, and completion bindings support.

return {
	"lervag/vimtex",
	lazy = true,
	ft = { "tex" },
	init = function()
		vim.g.vimtex_compiler_method = 'latexmk'
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_view_forward_search_on_start = false
		vim.g.vimtex_compiler_latexmk = {
			aux_dir = ".build",
			out_dir = ".build",
		}
	end,
}
