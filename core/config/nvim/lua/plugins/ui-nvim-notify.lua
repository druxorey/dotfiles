
-- Notifications manager displaying non-blocking popups in corner grids.
-- Handles animated warning alerts, message durations, and log states.
-- Features dynamic layout calculations to fit screen dimensions.

return {
	"rcarriga/nvim-notify",
	lazy = true,
	opts = {
		timeout = 3000,
		max_height = function()
			return math.floor(vim.o.lines * 0.75)
		end,
		max_width = function()
			return math.floor(vim.o.columns * 0.75)
		end,
		on_open = function(win)
			vim.api.nvim_win_set_config(win, { zindex = 100 })
		end,
	},
}
