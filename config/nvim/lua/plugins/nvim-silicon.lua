return {
	"michaelrommel/nvim-silicon",
	lazy = true,
	cmd = "Silicon",
	opts = {
		no_window_controls = true,
		to_clipboard = true,
		no_line_number = false,

		theme = "Dracula",
		background = "#BD93F9",

		shadow_blur_radius = 16,
		shadow_offset_x = 8,
		shadow_offset_y = 8,
		shadow_color = "#282A36",

		output = function()
			local png_path = "~/Pictures/Screenshots/code-screenshots/" .. os.date("!%Y-%m-%d_%H%M%S") .. "_code.png"
			local webp_path = png_path:gsub(".png$", ".webp")
			vim.schedule_wrap(function()
				os.execute("magick -quality 100 " .. png_path .. " " .. webp_path)
				os.execute("rm " .. png_path)
			end)()
			return png_path
		end,

		line_offset = function(args)
			return args.line1
		end
	}
}
