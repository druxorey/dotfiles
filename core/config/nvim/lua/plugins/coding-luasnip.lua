
-- Snippets manager for expanding text templates quickly.
-- Supports complex parsing, nested inputs, and dynamic visual nodes.
-- Integrates seamlessly with auto-completion engines like nvim-cmp.

return {
	"L3MON4D3/LuaSnip",
	lazy = true,
	dependencies = { "rafamadriz/friendly-snippets" },
	build = "make install_jsregexp",
	opts = {
		history = true,
		delete_check_events = "TextChanged",
	},
}
