
-- Formatting utility preserving user options and project preferences.
-- Supports running formatting tools asynchronously on save buffers.
-- Easily falls back to LSP formatting if external formatters are missing.

return {
	"stevearc/conform.nvim",
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			go = { "goimports", "gofmt" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			bash = { "shfmt" },
			sh = { "shfmt" },
			html = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			less = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
			tex = { "latexindent" },
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
