
-- Harpoon allows you to easily mark and quickly navigate between
-- active buffers. Provides persistent project marks and quick
-- file switcher interfaces

return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy",
	config = function()
		require("harpoon"):setup()
	end,
}
