local function load_prompt_from_file(file_path)
	local file = io.open(file_path, "r")
	if not file then
		error("ERROR: File could not be opened: " .. file_path)
	end
	local content = file:read("*a")
	file:close()
	return content
end

return {
	{
		"zbirenbaum/copilot-cmp",
		event = "VeryLazy",
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = { "CopilotStart" },
		config = function()
			vim.api.nvim_create_user_command("CopilotStart", function()
				require("copilot").setup()
				vim.cmd("Copilot enable")
			end, {})
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		event = "VeryLazy",
		opts = {
			model = "gpt-4o",
			prompts = {
				Commit = load_prompt_from_file(vim.fn.expand("~/.config/nvim/lua/plugins/prompts/commit.prompt")),
				Tasks = load_prompt_from_file(vim.fn.expand("~/.config/nvim/lua/plugins/prompts/tasks.prompt"))
			}
		}
	}
}
