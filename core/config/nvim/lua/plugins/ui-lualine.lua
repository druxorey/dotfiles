
-- Lualine statusline plugin providing a fast and customizable status bar.
-- Renders diagnostics, git branch info, file sizes, and editor modes.
-- Adapts colors dynamically to match the active general color scheme.

local colors = require("core.colorscheme")
local function generate_theme()
	return {
		normal = {
			a = { bg = colors.drx_color_accent,    fg = colors.drx_color_base, gui = "bold" },
			b = { bg = colors.drx_color_overlay, fg = colors.drx_color_text },
			c = { bg = colors.drx_color_surface,   fg = colors.drx_color_text },
		},
		insert = {
			a = { bg = colors.drx_color_green_2, fg = colors.drx_color_base, gui = "bold" },
			b = { bg = colors.drx_color_overlay, fg = colors.drx_color_text },
			c = { bg = colors.drx_color_surface, fg = colors.drx_color_text },
		},
		visual = {
			a = { bg = colors.drx_color_yellow_2, fg = colors.drx_color_base, gui = "bold" },
			b = { bg = colors.drx_color_overlay, fg = colors.drx_color_text },
			c = { bg = colors.drx_color_surface, fg = colors.drx_color_text },
		},
		replace = {
			a = { bg = colors.drx_color_red_2, fg = colors.drx_color_base, gui = "bold" },
			b = { bg = colors.drx_color_overlay, fg = colors.drx_color_text },
			c = { bg = colors.drx_color_surface, fg = colors.drx_color_text },
		},
		command = {
			a = { bg = colors.drx_color_orange_2, fg = colors.drx_color_base, gui = "bold" },
			b = { bg = colors.drx_color_overlay, fg = colors.drx_color_text },
			c = { bg = colors.drx_color_surface, fg = colors.drx_color_text },
		},
		inactive = {
			a = { bg = colors.drx_color_highlight, fg = colors.drx_color_text },
			b = { bg = colors.drx_color_overlay, fg = colors.drx_color_subtext },
			c = { bg = colors.drx_color_surface, fg = colors.drx_color_subtext },
		},
	}
end

return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
		return {
			options = {
				icons_enabled = true,
				theme = generate_theme(),
				component_separators = " ",
				section_separators = { left = "", right = "" },
				disabled_filetypes = { statusline = { "dashboard", "neo-tree" } },
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 100,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = {
					{
						function()
							local recording_register = vim.fn.reg_recording()
							if recording_register == "" then
								return ({
									n = "NORMAL",
									no = "NORMAL",
									v = "VISUAL",
									V = "V-LINE",
									[" "] = "V-BLOCK",
									i = "INSERT",
									ic = "INSERT",
									R = "REPLACE",
									Rv = "V-REPLACE",
									c = "COMMAND",
									cv = "EX",
									ce = "EX",
									r = "PROMPT",
									rm = "MORE",
									["r?"] = "CONFIRM",
									["!"] = "SHELL",
									t = "TERMINAL",
								})[vim.fn.mode()] or "UNKNOWN"
							else
								return "RECORDING @" .. recording_register
							end
						end,
						color = function()
							if vim.fn.reg_recording() ~= "" then
								return {
									bg = colors.drx_color_red_2,
									fg = colors.drx_color_base,
									gui = "bold",
								}
							else
								return { gui = "bold" }
							end
						end,
						separator = {
							left = "",
							right = " ",
						},
						icon = "",
					},
				},
				lualine_b = {
					{
						"buffers",
						symbols = {
							modified = "●",
							alternate_file = "",
							directory = "",
						},
						buffers_color = {
							active = "lualine_a_inactive",
							inactive = "lualine_b_inactive",
						},
						separator = {
							left = "",
							right = "",
						},
					},
				},
				lualine_c = { },
				lualine_x = { },
				lualine_y = { "diff", "diagnostics", "selectioncount", "searchcount" },
				lualine_z = {
					{
						"location",
						separator = {
							left = "",
							right = "",
						},
						icon = " ",
					},
				},
			},
			inactive_sections = {
				lualine_a = {
					{
						"mode",
						separator = {
							left = "",
							right = "",
						},
						left_padding = 2,
					},
				},
				lualine_b = {},
				lualine_c = { "%=", "filename" },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {
					{
						"location",
						separator = {
							left = "",
							right = "",
						},
						left_padding = 2,
					},
				},
			},
			extensions = { "fugitive", "lazy", "neo-tree" },
		}
	end,
}
