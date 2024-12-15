return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" },
	lazy = true,
	keys = {
		{
			"<leader>cff",
			function()
				require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
				vim.notify("Formatting Injected Languages", vim.log.levels.INFO)
			end,
			mode = { "n", "v" },
			desc = "Format Injected Languages",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
					rust = { "rustfmt", lsp_format = "fallback" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			cpp = { "clang-format" },
		},
	},
}
