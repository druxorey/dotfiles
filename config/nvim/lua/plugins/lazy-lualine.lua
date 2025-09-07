local dracula_colors = {
	gray = '#44475a',
	lightgray = '#5f6a8e',
	orange = '#ffb86c',
	purple = '#bd93f9',
	red = '#ff5555',
	yellow = '#f1fa8c',
	green = '#50fa7b',
	white = '#f8f8f2',
	black = '#282a36',
}

local function generate_theme(colors)
	return {
		normal = {
			a = { bg = colors.purple, fg = colors.black, gui = 'bold' },
			b = { bg = colors.lightgray, fg = colors.white },
			c = { bg = colors.gray, fg = colors.white },
		},
		insert = {
			a = { bg = colors.green, fg = colors.black, gui = 'bold' },
			b = { bg = colors.lightgray, fg = colors.white },
			c = { bg = colors.gray, fg = colors.white },
		},
		visual = {
			a = { bg = colors.yellow, fg = colors.black, gui = 'bold' },
			b = { bg = colors.lightgray, fg = colors.white },
			c = { bg = colors.gray, fg = colors.white },
		},
		replace = {
			a = { bg = colors.red, fg = colors.black, gui = 'bold' },
			b = { bg = colors.lightgray, fg = colors.white },
			c = { bg = colors.gray, fg = colors.white },
		},
		command = {
			a = { bg = colors.orange, fg = colors.black, gui = 'bold' },
			b = { bg = colors.lightgray, fg = colors.white },
			c = { bg = colors.gray, fg = colors.white },
		},
		inactive = {
			a = { bg = colors.gray, fg = colors.white, gui = 'bold' },
			b = { bg = colors.lightgray, fg = colors.white },
			c = { bg = colors.gray, fg = colors.white },
		},
	}
end

return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = {
		options = {
			icons_enabled = true,
			theme = generate_theme(dracula_colors),
			component_separators = "",
			section_separators = {
				left = "",
				right = ""
			},
			disabled_filetypes = {
				statusline = {"neo-tree", "dashboard"},
				winbar = {"neo-tree"}
			},
			ignore_focus = {},
			always_divide_middle = true,
			globalstatus = false,
			refresh = {
				statusline = 100,
				tabline = 1000,
				winbar = 1000
			}
		},
		sections = {
			lualine_a = {{
				function()
					local recording_register = vim.fn.reg_recording()
					if recording_register == '' then
						return ({
							n = "NORMAL",
							no = "NORMAL",
							v = "VISUAL",
							V = "V-LINE",
							[""] = "V-BLOCK",
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
						return 'RECORDING @' .. recording_register
					end
				end,
				color = function()
					if vim.fn.reg_recording() ~= '' then
						return { bg = dracula_colors.red, fg = dracula_colors.black, gui = 'bold' }
					else
						return {gui = 'bold'}
					end
				end,
				separator = {
					left = "",
					right = ""
				},
				icon = '',
				right_padding = 2
			}},
			lualine_b = {{
				"filename",
				icon = ' '
			}},
			lualine_c = {"branch", "diff", "diagnostics"},
			lualine_x = {"selectioncount", "searchcount"},
			lualine_y = {{
				"filesize",
				icon = '󰖡 ',
			}},
			lualine_z = {{
				"location",
				separator = {
					left = "",
					right = ""
				},
				left_padding = 2,
				icon = ''
			}}
		},
		inactive_sections = {
			lualine_a = {{
				"mode",
				separator = {
					left = "",
					right = ""
				},
				right_padding = 2
			}},
			lualine_b = {"branch", "diff", "diagnostics"},
			lualine_c = {"%=", "filename"},
			lualine_x = {},
			lualine_y = {"filetype", "filesize"},
			lualine_z = {{
				"location",
				separator = {
					left = "",
					right = ""
				},
				left_padding = 2
			}}
		},
		winbar = {},
		inactive_winbar = {},
		extensions = {}
	}
}
