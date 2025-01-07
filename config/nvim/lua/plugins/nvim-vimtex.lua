return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		vim.g.vimtex_compiler_method = 'latexmk'
		vim.g.vimtex_view_method = "zathura"
	end
}
