
-- Devicon font tables support utility providing buffer and file icons.
-- Mocks standard nvim-web-devicons integration for third party plugins.
-- Generates consistent filetype, category, and folder glyph indicators.

return {
	"echasnovski/mini.icons",
	opts = {},
	lazy = false,
	init = function()
		package.preload["nvim-web-devicons"] = function()
			require("mini.icons").mock_nvim_web_devicons()
			return package.loaded["nvim-web-devicons"]
		end
	end,
}
