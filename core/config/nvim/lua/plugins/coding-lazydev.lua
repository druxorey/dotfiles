
-- Neovim configuration development helper with dynamic typing.
-- Configures Lua LSP settings automatically for nvim APIs and plugins.
-- Enhances completion and diagnostics when writing local user configs.

return {
	"folke/lazydev.nvim",
	ft = "lua",
	cmd = "LazyDev",
	opts = {
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			{ path = "snacks.nvim", words = { "Snacks" } },
			{ path = "lazy.nvim", words = { "LazyVim" } },
			{ path = "nvim-lspconfig", words = { "lspconfig.settings" } },
		},
	},
}
