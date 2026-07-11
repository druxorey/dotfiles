
-- Silicon snapshot utility creating high-quality code screenshots.
-- Generates elegant images with customized backgrounds, shadows, and fonts.
-- Copies the generated snapshots directly to clipboard or saves locally.

return {
	"michaelrommel/nvim-silicon",
	lazy = true,
	cmd = "Silicon",
	opts = {
		no_window_controls = false,
		to_clipboard = true,
		no_line_number = false,

		theme = "Dracula",
		background = "#6272A4",

		shadow_blur_radius = 16,
		shadow_offset_x = 8,
		shadow_offset_y = 8,
		shadow_color = "#191A21",

		window_title = function()
			return vim.fn.fnamemodify(
				vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()),
				":t"
			)
		end,

		output = function()
			local png_path = "~/Pictures/Screenshots/code-screenshots/" .. os.date("!%Y-%m-%d_%H%M%S") .. "_code.png"
			local jpgxl_path = png_path:gsub(".png$", ".jxl")
			vim.schedule_wrap(function()
				os.execute("cjxl " .. png_path .. " " .. jpgxl_path .. " -q 100 --quiet")
				os.execute("rm " .. png_path)
			end)()
			return png_path
		end,

		line_offset = function(args)
			return args.line1
		end
	}
}
