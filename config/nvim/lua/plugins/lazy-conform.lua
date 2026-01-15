return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			c = { "clang-format" },
			cpp = { "clang-format" }
		},
		default_format_opts = {
			lsp_format = "fallback"
		},
		formatters = {
			["clang-format"] = {
				prepend_args = { "--style={UseTab: Always, IndentWidth: 4, TabWidth: 4}" }
			}
		}
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
