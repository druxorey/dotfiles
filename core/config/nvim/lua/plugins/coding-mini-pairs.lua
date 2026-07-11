
-- Auto pairs
-- Automatically inserts a matching closing character
-- when you type an opening character like `"`, `[`, or `(`.

return {
	"echasnovski/mini.pairs",
	event = "VeryLazy",
	opts = {
		modes = { insert = true, command = true, terminal = false },
		skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
		skip_ts = { "string" },
		skip_unbalanced = true,
		markdown = true,
	},
}
