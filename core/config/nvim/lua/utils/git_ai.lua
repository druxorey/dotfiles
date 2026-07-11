local M = {}

-- Show the commit selection picker in a floating window
function M.show_commit_picker(suggestions)
	local buf = vim.api.nvim_create_buf(false, true)

	local lines = {
		"# 󱊖 Press <CR> on a line to commit it.",
		"# 󱊖 In Visual mode, select lines and press <CR> to commit them.",
		"# 󱊖 Press 'q' to cancel.",
		"",
	}

	for line in string.gmatch(suggestions .. "\n", "([^\n]*)\n") do
		table.insert(lines, line)
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = true
	vim.bo[buf].filetype = "markdown"

	local width = math.min(90, vim.o.columns - 10)
	local height = math.min(#lines + 2, vim.o.lines - 10)
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
		title = " Git Commit Suggestions ",
		title_pos = "center",
	})

	local function do_commit(msg)
		-- Clean up trailing/leading whitespace and strip markdown header comment prefix if any
		local clean_msg = msg:gsub("^%s+", ""):gsub("%s+$", "")
		if clean_msg == "" or clean_msg:sub(1, 1) == "#" then
			vim.notify("Invalid commit message selected.", vim.log.levels.WARN, { title = "Git Generate Commit" })
			return
		end

		vim.api.nvim_win_close(win, true)

		-- Write message to a temporary file to support multi-line commit bodies safely
		local tmpfile = vim.fn.tempname()
		local f = io.open(tmpfile, "w")
		if f then
			f:write(clean_msg)
			f:close()

			local commit_res = vim.fn.system("git commit -F " .. vim.fn.shellescape(tmpfile))
			vim.fn.delete(tmpfile)

			if vim.v.shell_error == 0 then
				vim.notify(
					"Committed successfully:\n" .. clean_msg,
					vim.log.levels.INFO,
					{ title = "Git Generate Commit" }
				)
			else
				vim.notify(
					"Git commit failed:\n" .. commit_res,
					vim.log.levels.ERROR,
					{ title = "Git Generate Commit" }
				)
			end
		else
			vim.notify(
				"Failed to write temporary commit message file.",
				vim.log.levels.ERROR,
				{ title = "Git Generate Commit" }
			)
		end
	end

	-- Normal mode keymap
	vim.keymap.set("n", "<CR>", function()
		local current_line = vim.api.nvim_get_current_line()
		do_commit(current_line)
	end, { buffer = buf, silent = true, noremap = true })

	-- Visual mode keymap
	vim.keymap.set("v", "<CR>", function()
		local start_line = vim.fn.line("v")
		local end_line = vim.fn.line(".")
		if start_line > end_line then
			start_line, end_line = end_line, start_line
		end

		local sel_lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)
		local msg = table.concat(sel_lines, "\n")
		do_commit(msg)
	end, { buffer = buf, silent = true, noremap = true })

	-- Close mapping
	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf, silent = true, noremap = true })
end

function M.git_ai_commit()
	-- Verify I have staged files
	local diff = vim.fn.system("git diff --cached")
	if vim.v.shell_error ~= 0 or diff == "" then
		vim.notify("No staged changes to commit.", vim.log.levels.WARN, { title = "Git Generate Commit" })
		return
	end

	local prompt_file = vim.fn.stdpath("config") .. "/lua/prompts/ai-git-commit-message-generator.md"
	local prompt_content = ""
	if vim.fn.filereadable(prompt_file) == 1 then
		prompt_content = table.concat(vim.fn.readfile(prompt_file), "\n")
	else
		vim.notify("Prompt file not found at: " .. prompt_file, vim.log.levels.ERROR, { title = "Git Generate Commit" })
		return
	end

	local recent_commits = vim.fn.system('git log -n 25 --format="### Commit: %s%n%b" 2>/dev/null')

	-- Construct payload
	local full_input = prompt_content
	if recent_commits ~= "" then
		full_input = full_input
			.. "\n\n================ START OF RECENT COMMIT HISTORY (CONTEXT) ================\n\n"
			.. recent_commits
			.. "\n\n================ END OF RECENT COMMIT HISTORY (CONTEXT) ================\n"
	end
	full_input = full_input
		.. "\n\n================ START OF INPUT DATA (GIT DIFF) ================\n\n"
		.. diff
		.. "\n\n================ END OF INPUT DATA (GIT DIFF) ================\n"
		.. "\n================ START OF USER INPUT (PRIORITY) ================\n"

	vim.notify("Generating commit suggestions with mods...", vim.log.levels.INFO, {
		title = "Git Generate Commit",
	})

	-- Execute mods asynchronously
	local stdout = {}
	local stderr = {}

	local job_id = vim.fn.jobstart({ "mods", "--title", "Git Diff" }, {
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, data)
			if data then
				for _, line in ipairs(data) do
					if line ~= "" then
						table.insert(stdout, line)
					end
				end
			end
		end,
		on_stderr = function(_, data)
			if data then
				for _, line in ipairs(data) do
					if line ~= "" then
						table.insert(stderr, line)
					end
				end
			end
		end,
		on_exit = function(_, exit_code)
			if exit_code ~= 0 then
				local err_msg = table.concat(stderr, "\n")
				vim.notify(
					"mods execution failed:\n" .. err_msg,
					vim.log.levels.ERROR,
					{ title = "Git Generate Commit" }
				)
				return
			end

			local response = table.concat(stdout, "\n")
			if response == "" then
				vim.notify("No suggestions generated.", vim.log.levels.WARN, { title = "Git Generate Commit" })
				return
			end

			-- Open selection UI
			M.show_commit_picker(response)
		end,
	})

	-- Stream prompt input to stdin of mods
	vim.fn.chansend(job_id, full_input)
	vim.fn.chanclose(job_id, "stdin")
end

-- Show the branch selection picker in a floating window
function M.show_branch_picker(suggestions)
	local buf = vim.api.nvim_create_buf(false, true)

	local lines = {
		"# 󱊖 Press <CR> on a line to checkout that branch.",
		"# 󱊖 Press 'q' to cancel.",
		"",
	}

	-- Add the suggestion lines
	for line in string.gmatch(suggestions .. "\n", "([^\n]*)\n") do
		table.insert(lines, line)
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = true
	vim.bo[buf].filetype = "markdown"

	-- Calculate size for floating window
	local width = math.min(80, vim.o.columns - 10)
	local height = math.min(#lines + 2, vim.o.lines - 10)
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
		title = " Git Generate Branch Suggestions ",
		title_pos = "center",
	})

	local function do_checkout(branch_name)
		-- Clean up trailing/leading whitespace and strip markdown header comment prefix if any
		local clean_branch = branch_name:gsub("^%s+", ""):gsub("%s+$", "")
		if clean_branch == "" or clean_branch:sub(1, 1) == "#" then
			vim.notify("Invalid branch name selected.", vim.log.levels.WARN, { title = "Git Generate Branch" })
			return
		end

		-- Close window
		vim.api.nvim_win_close(win, true)

		local checkout_res = vim.fn.system("git checkout -b " .. vim.fn.shellescape(clean_branch))
		if vim.v.shell_error == 0 then
			vim.notify(
				"Created and checked out to branch: " .. clean_branch,
				vim.log.levels.INFO,
				{ title = "Git Generate Branch" }
			)
		else
			vim.notify(
				"Failed to create branch:\n" .. checkout_res,
				vim.log.levels.ERROR,
				{ title = "Git Generate Branch" }
			)
		end
	end

	-- Normal mode keymap
	vim.keymap.set("n", "<CR>", function()
		local current_line = vim.api.nvim_get_current_line()
		do_checkout(current_line)
	end, { buffer = buf, silent = true, noremap = true })

	-- Close mapping
	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf, silent = true, noremap = true })
end

-- Prompt user for input, generate branch name suggestions using mods, and show picker
function M.git_ai_branch()
	vim.ui.input({ prompt = "Explain branch objective (e.g. login OAuth feature): " }, function(input)
		if not input or input == "" then
			return
		end

		local prompt_file = vim.fn.stdpath("config") .. "/lua/prompts/ai-git-branch-name-generator.md"
		local prompt_content = ""
		if vim.fn.filereadable(prompt_file) == 1 then
			prompt_content = table.concat(vim.fn.readfile(prompt_file), "\n")
		else
			vim.notify(
				"Prompt file not found at: " .. prompt_file,
				vim.log.levels.ERROR,
				{ title = "Git Generate Branch" }
			)
			return
		end

		local full_input = prompt_content
			.. "\n\n================ START OF USER INPUT (PRIORITY) ================\n\n"
			.. input
			.. "\n\n================ END OF USER INPUT (PRIORITY) ================\n"

		vim.notify("Generating branch suggestions with mods...", vim.log.levels.INFO, {
			title = "Git Generate Branch",
		})

		local stdout = {}
		local stderr = {}

		local job_id = vim.fn.jobstart({ "mods", "--title", "Git Branch" }, {
			stdout_buffered = true,
			stderr_buffered = true,
			on_stdout = function(_, data)
				if data then
					for _, line in ipairs(data) do
						if line ~= "" then
							table.insert(stdout, line)
						end
					end
				end
			end,
			on_stderr = function(_, data)
				if data then
					for _, line in ipairs(data) do
						if line ~= "" then
							table.insert(stderr, line)
						end
					end
				end
			end,
			on_exit = function(_, exit_code)
				if exit_code ~= 0 then
					local err_msg = table.concat(stderr, "\n")
					vim.notify(
						"mods execution failed:\n" .. err_msg,
						vim.log.levels.ERROR,
						{ title = "Git Generate Branch" }
					)
					return
				end

				local response = table.concat(stdout, "\n")
				if response == "" then
					vim.notify("No suggestions generated.", vim.log.levels.WARN, { title = "Git Generate Branch" })
					return
				end

				M.show_branch_picker(response)
			end,
		})

		-- Stream prompt input to stdin of mods
		vim.fn.chansend(job_id, full_input)
		vim.fn.chanclose(job_id, "stdin")
	end)
end

return M
