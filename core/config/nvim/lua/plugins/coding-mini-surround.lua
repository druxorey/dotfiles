
-- Surround text objects editing utility to quickly wrap selections.
-- Allows adding, deleting, and replacing surrounding quotes or brackets.
-- Highly configurable mapping keys and smart search capabilities.

return {
	"echasnovski/mini.surround",
	event = "VeryLazy",
	opts = {
		mappings = {
			add = "gsa",
			delete = "gsd",
			find = "gsf",
			find_left = "gsF",
			highlight = "gsh",
			replace = "gsr",
			update_n_lines = "gsn",
		},
	},
}
