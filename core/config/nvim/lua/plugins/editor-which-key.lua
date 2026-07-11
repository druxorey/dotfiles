
-- Key bindings popup assistant displaying available shortcut completions.
-- Helps users discover mappings interactively in real time.
-- Automatically registers groups, commands, modes, and hidings.

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		icons = {
			rules = {
				{ pattern = "explorer", icon = " ", color = "red" },
			},
		},
		spec = {
			{ mode = { "n", "v" }, { "<leader>g", group = "git", icon = "󰊢 " } },
			{ mode = { "n", "v" }, { "<leader>gh", group = "hunks", icon = "󰊢 " } },
			{ mode = { "n", "v" }, { "<leader>f", group = "file/find" } },
			{ mode = { "n", "v" }, { "<leader>c", group = "code/compile" } },
			{ mode = { "n", "v" }, { "<leader>w", group = "windows" } },
			{ mode = { "n", "v" }, { "<leader>o", group = "options", icon = " " } },
			{ mode = { "n", "v" }, { "<leader>x", group = "diagnostics/quickfix" } },
			{ mode = { "n", "v" }, { "<leader>q", group = "quit/session" } },
			{ mode = { "n", "v" }, { "<leader>s", group = "search" } },
			{ mode = { "n", "v" }, { "<leader><tab>", group = "tabs" } },
			{ mode = { "n", "v" }, { "[", group = "prev" } },
			{ mode = { "n", "v" }, { "]", group = "next" } },
			{ mode = { "n", "v" }, { "g", group = "goto" } },
			{ mode = { "n", "v" }, { "gs", group = "surround" } },
			{ mode = { "n", "v" }, { "z", group = "fold" } },
			{ mode = { "n", "v" }, { "<localleader>l", group = "LaTeX", icon = " " } },
			{
				mode = { "n", "v" },
				{
					"<leader>b",
					group = "buffer",
					expand = function()
						return require("which-key.extras").expand.buf()
					end,
				},
			},
		},
	},
	config = function(_, opts)
		require("which-key").setup(opts)
	end,
}
