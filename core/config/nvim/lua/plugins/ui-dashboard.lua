
-- Startup dashboard screen rendering project shortcuts on session start.
-- Formats options like recent files, search triggers, and configs.
-- Provides a fast, beautiful start interface matching text logo layouts.

return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	opts = function()
		local is_obsidian = vim.fn.getcwd():find("/home/druxorey/Documents/A1 Obsidian") ~= nil

		local nvim_logo = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
		]]

		local obsidian_logo = [[
 ██████╗ ██████╗ ███████╗██╗██████╗ ██╗ █████╗ ███╗   ██╗
██╔═══██╗██╔══██╗██╔════╝██║██╔══██╗██║██╔══██╗████╗  ██║
██║   ██║██████╔╝███████╗██║██║  ██║██║███████║██╔██╗ ██║
██║   ██║██╔══██╗╚════██║██║██║  ██║██║██╔══██║██║╚██╗██║
╚██████╔╝██████╔╝███████║██║██████╔╝██║██║  ██║██║ ╚████║
╚═════╝ ╚═════╝ ╚══════╝╚═╝╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
		]]

		local logo = is_obsidian and obsidian_logo or nvim_logo
		logo = string.rep("\n", 8) .. logo .. "\n\n"

		local opts = {
			theme = "doom",
			hide = {
				statusline = false
			},
			config = {
				header = vim.split(logo, "\n"),
				center = {
					{
						action = "Telescope find_files",
						desc = " Find File",
						icon = " ",
						key = "f"
					},
					{
						action = "ene | startinsert",
						desc = " New File",
						icon = " ",
						key = "n"
					},
					{
						action = "Telescope oldfiles",
						desc = " Recent Files",
						icon = " ",
						key = "r"
					},
					{
						action = "Telescope live_grep",
						desc = " Find Text",
						icon = " ",
						key = "g"
					},
					{
						action = "Telescope find_files cwd=" .. vim.fn.stdpath("config"),
						desc = " Config",
						icon = " ",
						key = "c"
					},
					{
						action = 'lua require("persistence").load()',
						desc = " Restore Session",
						icon = " ",
						key = "s"
					},
					{
						action = "Lazy",
						desc = " Lazy",
						icon = "󰒲 ",
						key = "l"
					},
					{
						action = function()
							vim.api.nvim_input("<cmd>qa<cr>")
						end,
						desc = " Quit",
						icon = " ",
						key = "q"
					}
				},
				footer = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					return {"Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"}
				end
			}
		}

		for _, button in ipairs(opts.config.center) do
			button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
			button.key_format = "  %s"
		end

		return opts
	end,
}
