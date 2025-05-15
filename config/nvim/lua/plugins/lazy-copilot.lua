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
	},
	{
		"zbirenbaum/copilot.lua",
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		opts = {
			model = "gpt-4o",
			prompts = {
				Commit = load_prompt_from_file(vim.fn.expand("~/.config/nvim/lua/plugins/prompts/commit.prompt")),
				Tasks = load_prompt_from_file(vim.fn.expand("~/.config/nvim/lua/plugins/prompts/tasks.prompt"))
			}
		}
	}
}
