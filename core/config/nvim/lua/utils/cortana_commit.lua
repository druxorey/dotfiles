local M = {}

--- Formatting directive to ensure distinct commit suggestions and bullet list bodies are separated
local FORMATTING_DIRECTIVE = "Ensure double line breaks separate each of the 3 commit suggestions and before bullet lists."

--- Helper to strip ANSI sequences and spinner residue without collapsing empty lines
local function clean_output(text)
	text = text:gsub("\27%[[%d;]*[a-zA-Z]", "")
	text = text:gsub("\r\n", "\n"):gsub("\r", "\n")
	local lines = {}
	for _, raw_line in ipairs(vim.split(text, "\n", { plain = true })) do
		local cleaned = raw_line:gsub("^.*Generating%.*%s*", "")
		cleaned = cleaned:gsub("^[⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏%s]+", "")
		table.insert(lines, cleaned)
	end
	while #lines > 0 and vim.trim(lines[1]) == "" do
		table.remove(lines, 1)
	end
	while #lines > 0 and vim.trim(lines[#lines]) == "" do
		table.remove(lines)
	end
	return table.concat(lines, "\n")
end

--- Show commit suggestions in a floating picker window
function M.show_commit_picker(suggestions)
	local buf = vim.api.nvim_create_buf(false, true)

	local lines = {
		"# 󱊖 Press <CR> on a line to commit it.",
		"# 󱊖 In Visual mode, select lines and press <CR> to commit them.",
		"# 󱊖 Press 'q' or <Esc> to cancel.",
		"",
	}

	for _, line in ipairs(vim.split(suggestions, "\n", { plain = true })) do
		table.insert(lines, line)
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = true
	vim.bo[buf].filetype = "markdown"

	local width = math.min(95, vim.o.columns - 10)
	local height = math.min(#lines + 2, vim.o.lines - 6)
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
		title = " Cortana Commit Suggestions ",
		title_pos = "center",
	})

	local function do_commit(raw_msg)
		-- Filter out helper comment lines
		local msg_lines = {}
		for _, line in ipairs(vim.split(raw_msg, "\n", { plain = true })) do
			local trimmed = vim.trim(line)
			if not trimmed:match("^#") then
				table.insert(msg_lines, line)
			end
		end

		local clean_msg = vim.trim(table.concat(msg_lines, "\n"))
		if clean_msg == "" then
			vim.notify("Invalid commit message selected.", vim.log.levels.WARN, { title = "Cortana Commit" })
			return
		end

		-- Strip suggestion numbering prefixes like "1) ", "2. ", etc.
		clean_msg = clean_msg:gsub("^%s*%d+[%.)]%s*", "")

		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end

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
					{ title = "Cortana Commit" }
				)
			else
				vim.notify(
					"Git commit failed:\n" .. commit_res,
					vim.log.levels.ERROR,
					{ title = "Cortana Commit" }
				)
			end
		else
			vim.notify(
				"Failed to write temporary commit message file.",
				vim.log.levels.ERROR,
				{ title = "Cortana Commit" }
			)
		end
	end

	-- Keymaps for commit picker
	local opts = { buffer = buf, silent = true, noremap = true }

	vim.keymap.set("n", "<CR>", function()
		local current_line = vim.api.nvim_get_current_line()
		do_commit(current_line)
	end, opts)

	vim.keymap.set("v", "<CR>", function()
		local start_line = vim.fn.line("v")
		local end_line = vim.fn.line(".")
		if start_line > end_line then
			start_line, end_line = end_line, start_line
		end
		local sel_lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)
		do_commit(table.concat(sel_lines, "\n"))
	end, opts)

	vim.keymap.set("n", "q", function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end, opts)

	vim.keymap.set("n", "<Esc>", function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end, opts)
end

--- Prompts for an optional commit hint, generates scoped commits via cortana script, and opens picker
function M.cortana_commit()
	local is_git = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null"):gsub("%s+", "")
	if is_git ~= "true" then
		vim.notify("Not inside a Git repository.", vim.log.levels.WARN, { title = "Cortana Commit" })
		return
	end

	vim.ui.input({ prompt = "Cortana Commit Hint (optional): " }, function(hint)
		-- User cancelled input dialog
		if hint == nil then
			return
		end

		hint = vim.trim(hint)

		local cortana_bin = vim.fn.executable("cortana") == 1 and "cortana"
			or (vim.fn.stdpath("config") .. "/lua/utils/cortana")

		local full_hint = hint ~= "" and (hint .. " (" .. FORMATTING_DIRECTIVE .. ")") or FORMATTING_DIRECTIVE

		local cmd = { cortana_bin, "commit", full_hint }

		vim.notify("Generating commit suggestions with Cortana...", vim.log.levels.INFO, {
			title = "Cortana Commit",
		})

		local stdout = {}
		local stderr = {}

		local job_id = vim.fn.jobstart(cmd, {
			stdout_buffered = true,
			stderr_buffered = true,
			on_stdout = function(_, data)
				if data then
					for _, line in ipairs(data) do
						table.insert(stdout, line)
					end
				end
			end,
			on_stderr = function(_, data)
				if data then
					for _, line in ipairs(data) do
						table.insert(stderr, line)
					end
				end
			end,
			on_exit = function(_, exit_code)
				vim.schedule(function()
					if exit_code ~= 0 then
						local err_msg = clean_output(table.concat(stderr, "\n"))
						if err_msg == "" then
							err_msg = clean_output(table.concat(stdout, "\n"))
						end
						vim.notify(
							"Cortana commit failed:\n" .. err_msg,
							vim.log.levels.ERROR,
							{ title = "Cortana Commit" }
						)
						return
					end

					local raw_response = table.concat(stdout, "\n")
					local response = clean_output(raw_response)
					if vim.trim(response) == "" then
						vim.notify("No suggestions generated.", vim.log.levels.WARN, { title = "Cortana Commit" })
						return
					end

					M.show_commit_picker(response)
				end)
			end,
		})

		-- Immediately close stdin so cortana script doesn't block waiting on pipe EOF
		vim.fn.chanclose(job_id, "stdin")
	end)
end

return M
