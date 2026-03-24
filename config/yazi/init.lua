require("gvfs"):setup({
	which_keys = "1234567890qwertyuiopasdfghjklzxcvbnm-=[]\\;',./!@#$%^&*()_+{}|:\"<>?",
	blacklist_devices = { { name = "Wireless Device", scheme = "mtp" }, { scheme = "file" }, "Device Name"},
	save_path = os.getenv("HOME") .. "/.config/yazi/gvfs.private",
	save_path_automounts = os.getenv("HOME") .. "/.config/yazi/gvfs_automounts.private",
	input_position = { "center", y = 0, w = 60 },
	password_vault = "keyring",
	key_grip = "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB",
	save_password_autoconfirm = true,
})

require("full-border"):setup ({
	type = ui.Border.ROUNDED,
})

require("git"):setup ({
	order = 1500,
})

require("yatline"):setup({
	section_separator = { open = "", close = "" },
	part_separator = { open = " ", close = " " },
	inverse_separator = { open = "a", close = "" },

	padding = { inner = 1, outer = 1 },

	style_a = {
		bg = "white",
		fg = "black",
		bg_mode = {
			normal = "blue",
			select = "yellow",
			un_set = "red",
		},
	},
	style_b = { bg = "brightblack", fg = "brightwhite" },
	style_c = { bg = "black", fg = "brightwhite" },

	permissions_t_fg = "green",
	permissions_r_fg = "yellow",
	permissions_w_fg = "red",
	permissions_x_fg = "cyan",
	permissions_s_fg = "white",

	tab_width = 20,

	selected = { icon = "󰻭", fg = "yellow" },
	copied = { icon = "", fg = "green" },
	cut = { icon = "", fg = "red" },

	files = { icon = "", fg = "blue" },
	filtereds = { icon = "", fg = "magenta" },

	total = { icon = "󰮍", fg = "yellow" },
	success = { icon = "", fg = "green" },
	failed = { icon = "", fg = "red" },

	show_background = false,

	display_header_line = true,
	display_status_line = true,

	component_positions = { "header", "tab", "status" },

	header_line = {
		left = {
			section_a = {
				{ type = "line", name = "tabs" },
			},
			section_b = {},
			section_c = {},
		},
		right = {
			section_c = {
				{ type = "string", name = "hovered_path" },
			}
		}
	},

	status_line = {
		left = {
			section_a = {
				{ type = "string", name = "tab_mode" },
			},
			section_b = {
				{ type = "string", name = "hovered_size" },
			},
			section_c = {
				{ type = "coloreds", name = "count" },
			},
		},
		right = {
			section_a = {
				{ type = "string", name = "cursor_position" },
			},
			section_b = {
				{ type = "string", name = "hovered_file_extension", params = { true } },
			},
			section_c = {
				{ type = "coloreds", name = "permissions" },
			},
		},
	},
})
