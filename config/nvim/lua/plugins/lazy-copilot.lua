return {
	{
		"zbirenbaum/copilot-cmp",
	},
	{
		"zbirenbaum/copilot.lua",
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		opts = {
			prompts = {
				Commit = "> /COPILOT_GENERATE\n\nWrite 3 versions of commit messages for the change following the 'Conventional Commits' convention. Ensure the title has a maximum of 50 characters and the message is wrapped at 72 characters.",
			}
		}
	},
}
