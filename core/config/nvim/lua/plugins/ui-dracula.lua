
-- Dracula color scheme configuration providing dark aesthetic themes.
-- Features tailored highlight settings for LSP diagnostics and statuslines.
-- Offers a highly customizable dark mode visual palette.

return {
	"Mofiqul/dracula.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local dracula = require("dracula")
		local colorscheme = require("core.colorscheme")
		local is_light = (colorscheme.drx_color_surface == "#FFFBEB")

		local colors = {
			bg = colorscheme.drx_color_surface,
			fg = colorscheme.drx_color_text,
			selection = colorscheme.drx_color_highlight,
			comment = colorscheme.drx_color_comment,
			red = is_light and colorscheme.drx_color_purple_2 or colorscheme.drx_color_red_2,
			orange = colorscheme.drx_color_orange_2,
			yellow = colorscheme.drx_color_yellow_2,
			green = colorscheme.drx_color_green_2,
			purple = is_light and colorscheme.drx_color_red_2 or colorscheme.drx_color_purple_2,
			cyan = colorscheme.drx_color_cyan_2,
			pink = colorscheme.drx_color_pink_2,
			bright_red = colorscheme.drx_color_red_1,
			bright_green = colorscheme.drx_color_green_1,
			bright_yellow = colorscheme.drx_color_yellow_1,
			bright_blue = is_light and colorscheme.drx_color_blue_1 or colorscheme.drx_color_purple_1,
			bright_magenta = colorscheme.drx_color_pink_1,
			bright_cyan = colorscheme.drx_color_cyan_1,
			bright_white = colorscheme.drx_color_white,
			menu = is_light and colorscheme.drx_color_base or colorscheme.drx_color_surface,
			visual = colorscheme.drx_color_overlay,
			gutter_fg = is_light and colorscheme.drx_color_deactivate or colorscheme.drx_color_highlight,
			nontext = is_light and colorscheme.drx_color_comment or colorscheme.drx_color_overlay,
			white = is_light and colorscheme.drx_color_text or colorscheme.drx_color_subtext,
			black = colorscheme.drx_color_base,
		}

		dracula.setup({
			colors = colors,
			show_end_of_buffer = true,
			transparent_bg = false,
			-- Use visual color for light theme, selection color for dark theme
			lualine_bg_color = (colors.bg == "#FFFBEB") and colors.visual or colors.selection,
			italic_comment = true,
			overrides = {},
		})
		vim.cmd("colorscheme dracula")
	end,
}
