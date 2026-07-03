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

require("yatline"):setup({
	section_separator = { open = "", close = "" },
	part_separator = { open = " ", close = " " },
	inverse_separator = { open = "", close = "" },

	padding = { inner = 1, outer = 1 },

	style_a = {
		bg = "#6272A4",
		fg = "#191A21",
		bg_mode = {
			normal = "#BD93F9",
			select = "#F1FA8C",
			un_set = "#FF5555",
		},
	},
	style_b = { bg = "#343746", fg = "#F8F8F2" },
	style_c = { bg = "#191A21", fg = "#F8F8F2" },

	permissions_t_fg = "#50FA7B",
	permissions_r_fg = "#F1FA8C",
	permissions_w_fg = "#FF5555",
	permissions_x_fg = "#72D0E4",
	permissions_s_fg = "#F8F8F2",

	tab_width = 20,

	selected = { icon = "󰻭", fg = "#F1FA8C" },
	copied = { icon = "", fg = "#50FA7B" },
	cut = { icon = "", fg = "#FF5555" },

	files = { icon = "", fg = "#BD93F9" },
	filtereds = { icon = "", fg = "#FF79C6" },

	total = { icon = "󰮍", fg = "#F1FA8C" },
	success = { icon = "", fg = "#50FA7B" },
	failed = { icon = "", fg = "#FF5555" },

	show_background = false,

	display_header_line = true,
	display_status_line = true,

	component_positions = { "header", "tab", "status" },

	header_line = {
		left = {
			section_a = {
				{ type = "line", name = "tabs" },
			},
		},
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
				{ type = "string", name = "hovered_path" },
			},
		},
		right = {
			section_a = {
				{ type = "string", name = "cursor_position" },
			},
			section_c = {
				{ type = "coloreds", name = "permissions" },
			},
		},
	},
})
