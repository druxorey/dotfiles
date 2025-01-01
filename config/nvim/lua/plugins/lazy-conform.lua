return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cc",
			function()
				require("conform").format({ async = true })
				vim.notify("Buffer formatted", vim.log.levels.INFO)
			end,
			mode = "",
			desc = "Format buffer"
		}
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			cpp = { "clang-format" }
		},
		default_format_opts = {
			lsp_format = "fallback"
		},
		formatters = {
			clang_format = {
				prepend_args = { "--use-tabs", "--tab-width=4" }
			}
		}
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
