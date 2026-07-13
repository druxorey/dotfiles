local M = {}

-- Show response in a floating window
function M.show_response(response)
	local buf = vim.api.nvim_create_buf(false, true)

	local lines = {}
	for line in string.gmatch(response .. "\n", "([^\n]*)\n") do
		table.insert(lines, line)
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].filetype = "markdown"
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false

	-- Determine window sizing
	local width = math.min(120, vim.o.columns - 10)
	local height = math.min(30, vim.o.lines - 10)
	if height < 5 then
		height = 5
	end

	local row = math.ceil((vim.o.lines - height) / 2)
	local col = math.ceil((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " Ai Response ",
		title_pos = "center",
	})

	vim.wo[win].wrap = true

	-- Keymaps for the floating window
	local opts = { buffer = buf, silent = true, noremap = true }

	-- Close mappings
	vim.keymap.set("n", "q", function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end, vim.tbl_extend("force", opts, { desc = "Close window" }))

	vim.keymap.set("n", "<esc>", function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end, vim.tbl_extend("force", opts, { desc = "Close window" }))

	-- Copy entire response mapping
	vim.keymap.set("n", "y", function()
		local full_text = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
		vim.fn.setreg("+", full_text)
		vim.fn.setreg('"', full_text)
		vim.notify("Response copied to clipboard!", vim.log.levels.INFO, { title = "Ai Assistant" })
	end, vim.tbl_extend("force", opts, { desc = "Copy entire response" }))
end

-- Ask Ai with the current buffer context or visual selection
function M.ask_ai()
	local mode = vim.api.nvim_get_mode().mode
	local is_visual = mode:match("[vV]") or mode == "\22"

	local context_text = ""
	local current_buf = vim.api.nvim_get_current_buf()
	local file_path = vim.api.nvim_buf_get_name(current_buf)

	if is_visual then
		local start_line = vim.fn.line("v")
		local end_line = vim.fn.line(".")
		if start_line > end_line then
			start_line, end_line = end_line, start_line
		end
		local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
		context_text = table.concat(lines, "\n")
		-- Force exit visual mode to clean editor state
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "x", true)
	else
		local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)
		context_text = table.concat(lines, "\n")
	end

	vim.ui.input({ prompt = "Ask Ai: " }, function(input)
		if not input or input == "" then
			return
		end

		-- Read system prompt
		local prompt_file = vim.fn.stdpath("config") .. "/lua/prompts/ai-general-assistant.md"
		local prompt_content = ""
		if vim.fn.filereadable(prompt_file) == 1 then
			prompt_content = table.concat(vim.fn.readfile(prompt_file), "\n")
		else
			prompt_content = "You are a helpful programming assistant. Provide clear, concise, and accurate answers."
		end

		-- Construct payload input
		local full_input = prompt_content
		if context_text ~= "" then
			if is_visual then
				local filename_label = file_path ~= "" and vim.fn.fnamemodify(file_path, ":t") or "Selection"
				full_input = full_input
					.. "\n\n================ START OF SELECTED CODE CONTEXT ("
					.. filename_label
					.. ") ================\n\n"
					.. context_text
					.. "\n\n================ END OF SELECTED CODE CONTEXT ("
					.. filename_label
					.. ") ================\n"
			else
				if file_path ~= "" and vim.bo[current_buf].buftype == "" then
					local filename_label = vim.fn.fnamemodify(file_path, ":t")
					full_input = full_input
						.. "\n\n================ START OF FILE CONTEXT ("
						.. filename_label
						.. ") ================\n\n"
						.. context_text
						.. "\n\n================ END OF FILE CONTEXT ("
						.. filename_label
						.. ") ================\n"
				end
			end
		end

		full_input = full_input
			.. "\n\n================ START OF USER QUESTION ================\n\n"
			.. input
			.. "\n\n================ END OF USER QUESTION ================\n"

		vim.notify("Querying Ai with mods...", vim.log.levels.INFO, {
			title = "Ai Assistant",
		})

		local stdout = {}
		local stderr = {}

		local job_id = vim.fn.jobstart({ "mods", "--title", "Ai Assistant" }, {
			stdout_buffered = true,
			stderr_buffered = true,
			on_stdout = function(_, data)
				if data then
					vim.list_extend(stdout, data)
				end
			end,
			on_stderr = function(_, data)
				if data then
					vim.list_extend(stderr, data)
				end
			end,
			on_exit = function(_, exit_code)
				if exit_code ~= 0 then
					local err_msg = table.concat(stderr, "\n")
					vim.notify(
						"mods execution failed:\n" .. err_msg,
						vim.log.levels.ERROR,
						{ title = "Ai Assistant" }
					)
					return
				end

				-- Remove trailing empty string elements that jobstart might produce if output ends with a newline
				while #stdout > 0 and stdout[#stdout] == "" do
					table.remove(stdout)
				end

				local response = table.concat(stdout, "\n")
				if response == "" then
					vim.notify("No response generated.", vim.log.levels.WARN, { title = "Ai Assistant" })
					return
				end

				M.show_response(response)
			end,
		})

		-- Stream prompt input to stdin of mods
		vim.fn.chansend(job_id, full_input)
		vim.fn.chanclose(job_id, "stdin")
	end)
end

return M
