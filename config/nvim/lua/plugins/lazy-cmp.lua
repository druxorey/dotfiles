return {
	"hrsh7th/nvim-cmp",
	dependencies = {"hrsh7th/cmp-emoji"},
	opts = function(_, opts)
		local has_words_before = function()
			unpack = unpack or table.unpack
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		local luasnip = require("luasnip")
		local cmp = require("cmp")

		opts.mapping = vim.tbl_extend("force", opts.mapping, {
			["<CR>"] = cmp.config.disable,
			["<Tab>"] = cmp.mapping.confirm({
				select = true
			}),
			["<C-j>"] = cmp.mapping(function(fallback)
			end, {"i", "s"})
		})
	end
}
