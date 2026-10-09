
-- ========================================================================== --
--
--                        ██╗   ██╗ █████╗ ███████╗██╗
--                        ╚██╗ ██╔╝██╔══██╗╚══███╔╝██║
--                         ╚████╔╝ ███████║  ███╔╝ ██║
--                          ╚██╔╝  ██╔══██║ ███╔╝  ██║
--                           ██║   ██║  ██║███████╗██║
--                           ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝
--
--                                   INIT
--                         https://github.com/druxorey
--
-- ========================================================================== --

require("gvfs"):setup({
	which_keys = "1234567890qwertyuiopasdfghjklzxcvbnm-=[]\\;',./!@#$%^&*()_+{}|:\"<>?",
	blacklist_devices = { { name = "Wireless Device", scheme = "mtp" }, { scheme = "file" }, "Device Name" },
	save_path = os.getenv("HOME") .. "/.config/yazi/gvfs.private",
	save_path_automounts = os.getenv("HOME") .. "/.config/yazi/gvfs_automounts.private",
	input_position = { "center", y = 0, w = 60 },
	password_vault = "keyring",
	save_password_autoconfirm = true,
})

require("full-border"):setup({
	type = ui.Border.ROUNDED,
})

require("omp"):setup({ config = "/home/druxorey/.config/oh-my-posh/yazi.omp.json" })

require("center-media"):setup({
	target = "mediainfo",
	horizontal = true,
	vertical = true,
	text = "block",

	sections = {
		audio = { "General", "Audio" },
	},
	skip_labels = {
		"Complete name",
		"CompleteName_Last",
		"Unique ID",
		"File size",
		"Format/Info",
		"Codec ID/Info",
		"MD5 of the unencoded content",
		"Color space",
		"Bit depth",
		"Compression",
		"Compression mode",
		"Stream size",
	},
	skip_section_labels = {},
})

require("sduf"):setup({
  filled_bg       = "#37EB62", -- bar color (normal usage)
  filled_bg_warn  = "#FFB86C", -- bar color when usage >= warn_at
  filled_bg_danger= "#F75353", -- bar color when usage >= danger_at
  unfilled_bg     = "#44475A", -- empty part of the bar
  text_fg         = "#F8F8F2", -- bar text color
  error_fg        = "red",     -- color of the "Disk: ??" fallback
  warn_at         = 75,        -- threshold (%) for the warn color
  danger_at       = 90,        -- threshold (%) for the danger color
  border_open     = "",       -- left cap of the bar
  border_close    = "",       -- right cap of the bar
  margin          = " ",       -- padding around the meter
  position        = 2900,      -- status bar priority
})
