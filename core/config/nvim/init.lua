
-- ========================================================================== --
--
--
--          ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗
--          ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║
--          ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║
--          ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║
--          ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
--          ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
--
--                                   INIT
--                         https://github.com/druxorey
--
-- ========================================================================== --

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({{"Failed to clone lazy.nvim:\n", "ErrorMsg"}, {out, "WarningMsg"}, {"\nPress any key to exit..."}}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Prioritize Mason binaries over system-wide executables
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

require("core.options")   -- Set options and leader keys first
require("core.keymaps")   -- Load keymaps
require("core.autocmds")  -- Load autocommands
require("lazy").setup({
	defaults = {
		lazy = false,
		version = false
	},
	spec = {
		{ import = "plugins" },
	},
	install = {
		colorscheme = { "dracula" },
		git = {
			args = {
				"--filter=blob:none",
				"--no-tags",
			},
		},
	},
	checker = {
		enabled = false
	},
	performance = {
		rtp = {
			disabled_plugins = {"gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin"}
		},
		cache = {
			enabled = true,
		}
	}
})
