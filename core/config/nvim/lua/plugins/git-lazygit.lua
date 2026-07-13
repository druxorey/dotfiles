
-- LazyGit integration wrapper enabling Git GUI windows within Neovim.
-- Allows visual commits, branches checks, and hunks management.
-- Requires lazygit CLI binary to be installed on the system.

return {
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
}
