return {
	"lervag/vimtex",
	dependencies = {},
	lazy = false,
	config = function()
		require("markview").setup()
		vim.g.vimtex_compiler_method = 'latexmk'
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_view_forward_search_on_start = false
		vim.g.vimtex_compiler_latexmk = {
			aux_dir = ".build",
			out_dir = ".build",
		}
	end
}
