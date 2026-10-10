local M = {}

local FORMATTING_DIRECTIVE = "IMPORTANT: Always use double line breaks between distinct paragraphs, lists, and code blocks to maintain clean Markdown readability."

--- Helper to strip ANSI sequences and spinner residue without collapsing empty lines
local function clean_output(text)
	text = text:gsub("\27%[[%d;]*[a-zA-Z]", "")
	text = text:gsub("\r\n", "\n"):gsub("\r", "\n")
	local lines = {}
	for _, rawLine in ipairs(vim.split(text, "\n", { plain = true })) do
		local cleaned = rawLine:gsub("^.*Generating%.*%s*", "")
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

--- Display Cortana's markdown response in a right panel split
function M.show_response(response)
	local lines = vim.split(response, "\n", { plain = true })

	vim.cmd("botright vsplit")
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(win, buf)

	local targetWidth = math.max(60, math.floor(vim.o.columns * 0.4))
	vim.api.nvim_win_set_width(win, targetWidth)

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = true
	vim.bo[buf].filetype = "markdown"
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false

	vim.wo[win].wrap = true
	vim.wo[win].number = false
	vim.wo[win].relativenumber = false
	vim.wo[win].signcolumn = "no"

	local opts = { buffer = buf, silent = true, noremap = true }

	-- Close keymap (q)
	vim.keymap.set("n", "q", function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end, vim.tbl_extend("force", opts, { desc = "Close Cortana Panel" }))

	-- Copy entire response (y)
	vim.keymap.set("n", "y", function()
		local fullText = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
		vim.fn.setreg("+", fullText)
		vim.fn.setreg('"', fullText)
		vim.notify("Response copied to clipboard!", vim.log.levels.INFO, { title = "Cortana" })
	end, vim.tbl_extend("force", opts, { desc = "Copy entire response" }))
end

--- Open a centered prompt dialog for editing user query, then query Cortana
function M.cortana()
	local mode = vim.api.nvim_get_mode().mode
	local isVisual = mode:match("[vV]") or mode == "\22"

	local contextLines = {}
	local ext = vim.fn.expand("%:e")
	local currentBuffer = vim.api.nvim_get_current_buf()

	if isVisual then
		local startLine = vim.fn.line("v")
		local endLine = vim.fn.line(".")
		if startLine > endLine then
			startLine, endLine = endLine, startLine
		end
		contextLines = vim.api.nvim_buf_get_lines(0, startLine - 1, endLine, false)
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "x", true)
	else
		contextLines = vim.api.nvim_buf_get_lines(currentBuffer, 0, -1, false)
	end

	local tempContextFile = nil
	local hasContent = false
	for _, l in ipairs(contextLines) do
		if vim.trim(l) ~= "" then
			hasContent = true
			break
		end
	end

	if hasContent then
		tempContextFile = vim.fn.tempname()
		if ext ~= "" then
			tempContextFile = tempContextFile .. "." .. ext
		end
		vim.fn.writefile(contextLines, tempContextFile)
	end

	-- Create centered floating window for prompt input
	local input_buf = vim.api.nvim_create_buf(false, true)
	vim.bo[input_buf].buftype = "nofile"
	vim.bo[input_buf].bufhidden = "wipe"
	vim.bo[input_buf].filetype = "markdown"

	local width = math.min(80, vim.o.columns - 10)
	local height = math.min(10, vim.o.lines - 6)
	local row = math.ceil((vim.o.lines - height) / 2)
	local col = math.ceil((vim.o.columns - width) / 2)

	local inputWindow = vim.api.nvim_open_win(input_buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " Ask Cortana (<CR> or <C-s> to submit, <Esc>/q to cancel) ",
		title_pos = "center",
	})

	vim.wo[inputWindow].wrap = true
	vim.wo[inputWindow].linebreak = true
	vim.wo[inputWindow].breakindent = true

	local function cleanup_temp()
		if tempContextFile and vim.fn.filereadable(tempContextFile) == 1 then
			vim.fn.delete(tempContextFile)
			tempContextFile = nil
		end
	end

	local function submit_query()
		local lines = vim.api.nvim_buf_get_lines(input_buf, 0, -1, false)
		local query = vim.trim(table.concat(lines, "\n"))

		if query == "" then
			vim.notify("Prompt is empty.", vim.log.levels.WARN, { title = "Cortana" })
			return
		end

		if vim.api.nvim_win_is_valid(inputWindow) then
			vim.api.nvim_win_close(inputWindow, true)
		end

		vim.notify("Querying Cortana...", vim.log.levels.INFO, { title = "Cortana" })

		local cortanaBin = vim.fn.executable("cortana") == 1 and "cortana"
			or (vim.fn.stdpath("config") .. "/lua/utils/cortana")

		local cmd = { cortanaBin, "science", "-S" }
		if tempContextFile then
			table.insert(cmd, "-f")
			table.insert(cmd, tempContextFile)
		end

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
					cleanup_temp()

					if exit_code ~= 0 then
						local err_msg = clean_output(table.concat(stderr, "\n"))
						if err_msg == "" then
							err_msg = clean_output(table.concat(stdout, "\n"))
						end
						vim.notify("Cortana query failed:\n" .. err_msg, vim.log.levels.ERROR, { title = "Cortana" })
						return
					end

					local raw_response = table.concat(stdout, "\n")
					local response = clean_output(raw_response)
					if response == "" then
						vim.notify("No response generated.", vim.log.levels.WARN, { title = "Cortana" })
						return
					end

					M.show_response(response)
				end)
			end,
		})

		-- Send query along with formatting directive to ensure double newlines between paragraphs
		local payload = query .. "\n\n(" .. FORMATTING_DIRECTIVE .. ")"
		vim.fn.chansend(job_id, payload)
		vim.fn.chanclose(job_id, "stdin")
	end

	local function cancel_input()
		cleanup_temp()
		if vim.api.nvim_win_is_valid(inputWindow) then
			vim.api.nvim_win_close(inputWindow, true)
		end
	end

	local opts = { buffer = input_buf, silent = true, noremap = true }

	-- Submit bindings
	vim.keymap.set("n", "<CR>", submit_query, opts)
	vim.keymap.set({ "n", "i" }, "<C-s>", submit_query, opts)

	-- Cancel bindings
	vim.keymap.set("n", "q", cancel_input, opts)
	vim.keymap.set("n", "<Esc>", cancel_input, opts)

	-- Start in insert mode
	vim.cmd("startinsert")
end

--- Proxy for cortana_commit
function M.cortana_commit()
	require("utils.cortana_commit").cortana_commit()
end

return M
