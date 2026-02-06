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
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = {},
		config = function(_)
			local c = require("copilot.client")
			c.teardown()
			require("copilot.panel").teardown()
		end,
		keys = {
			{
				"<leader>as",
				function()
					local client = require("copilot.client")

					if client.is_disabled() then
						vim.cmd("Copilot enable")
						vim.notify("Copilot Enabled", vim.log.levels.INFO)
					else
						vim.cmd("Copilot disable")
						vim.notify("Copilot Disabled", vim.log.levels.INFO)
					end
				end,
				desc = "Toggle Copilot",
			},
		},
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		cmd = { "CopilotChat", "CopilotChatOpen", "CopilotChatToggle" },
		event = {},
		dependencies = { "zbirenbaum/copilot.lua" },
		keys = {
			{ "<leader>aa", mode = { "n" }, false },
			{ "<C-l>",      mode = { "n" }, false },
		},
		opts = {
			model = "gemini-3-flash-preview",
			language = "Spanish",
			auto_insert_mode = true,
			mappings = {
				reset = {
					normal = "",
					insert = "",
				},
			},
			prompts = {
				Commit = load_prompt_from_file(vim.fn.expand("~/.config/nvim/lua/plugins/prompts/commit.prompt")),
				Tasks = load_prompt_from_file(vim.fn.expand("~/.config/nvim/lua/plugins/prompts/tasks.prompt"))
			}
		}
	}
}
