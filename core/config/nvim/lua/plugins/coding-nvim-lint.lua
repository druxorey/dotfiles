
-- Linter utility linking code validation checkers to buffer events.
-- Resolves correct linter binaries for specific file types on save.
-- Supports non-blocking asynchronous execution and output debouncing.

return {
	"mfussenegger/nvim-lint",
	event = "VeryLazy",
	opts = {
		events = { "BufWritePost", "BufReadPost", "InsertLeave" },
		linters_by_ft = {
			fish = { "fish" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			go = { "golangci-lint" },
			python = { "ruff" },
			bash = { "shellcheck" },
			yaml = { "yamllint" },
			latex = { "chktex" },
			css = { "stylelint" },
			less = { "stylelint" },
		},
	},
	config = function(_, opts)
		local lint = require("lint")
		lint.linters_by_ft = opts.linters_by_ft

		local function debounce(ms, fn)
			local timer = vim.uv.new_timer()
			return function(...)
				local argv = { ... }
				timer:start(ms, 0, function()
					timer:stop()
					vim.schedule_wrap(fn)(unpack(argv))
				end)
			end
		end

		local function try_lint()
			local names = lint._resolve_linter_by_ft(vim.bo.filetype)
			names = vim.list_extend({}, names)
			if #names == 0 then
				vim.list_extend(names, lint.linters_by_ft["_"] or {})
			end
			vim.list_extend(names, lint.linters_by_ft["*"] or {})

			local ctx = { filename = vim.api.nvim_buf_get_name(0) }
			ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
			names = vim.tbl_filter(function(name)
				local linter = lint.linters[name]
				return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
			end, names)

			if #names > 0 then
				lint.try_lint(names)
			end
		end

		vim.api.nvim_create_autocmd(opts.events, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = debounce(100, try_lint),
		})
	end,
}
