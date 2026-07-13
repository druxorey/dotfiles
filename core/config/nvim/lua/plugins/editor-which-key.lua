
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
				{ pattern = "explorer", icon = "󰙅 ", color = "orange" },
				{ pattern = "harpoon", icon = "  ", color = "cyan" },
				{ pattern = "options", icon = " ", color = "white" },
				{ pattern = "terminal", icon = " ", color = "red" },
				{ pattern = "ai", icon = "󱜙 ", color = "red" },
				{ pattern = "keywordprg", icon = "󰗚 ", color = "green" },
				{ pattern = "yank", icon = " ", color = "pink" },
				{ pattern = "keymaps", icon = "󰌌 ", color = "purple" },
				{ pattern = "scratch", icon = "󰏫 ", color = "cyan" },
			},
		},
		spec = {
			{ mode = { "n", "v" }, { "<leader>g", group = "Git", icon = "󰊢 " } },
			{ mode = { "n", "v" }, { "<leader>s", group = "Search" } },
			{ mode = { "n", "v" }, { "<leader>f", group = "File" } },
			{ mode = { "n", "v" }, { "<leader>c", group = "Code" } },
			{ mode = { "n", "v" }, { "<leader>w", group = "Windows" } },
			{ mode = { "n", "v" }, { "<leader>u", group = "Ui" } },
			{ mode = { "n", "v" }, { "<leader>h", group = "Harpoon" } },
			{ mode = { "n", "v" }, { "<leader>t", group = "Terminal" } },
			{ mode = { "n", "v" }, { "<leader>x", group = "Diagnostics/Quickfix" } },
			{ mode = { "n", "v" }, { "<leader>q", group = "Quit/Session" } },
			{ mode = { "n", "v" }, { "<leader><tab>", group = "Tabs" } },
			{ mode = { "n", "v" }, { "[", group = "prev" } },
			{ mode = { "n", "v" }, { "]", group = "next" } },
			{ mode = { "n", "v" }, { "g", group = "goto" } },
			{ mode = { "n", "v" }, { "z", group = "fold" } },
			{ mode = { "n", "v" }, { "gs", group = "surround" } },
			{ mode = { "n", "v" }, { "<leader>gh", group = "Hunks" } },
			{ mode = { "n", "v" }, { "<localleader>l", group = "LaTeX", icon = " " } },
			{
				mode = { "n", "v" },
				{
					"<leader>b",
					group = "Buffer",
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
