local M = {}

-- Escape and clear search highlight
-- @return string
function M.escape_and_clear()
	vim.cmd("noh")
	return "<esc>"
end

-- Create a new file with a prompt for name
function M.create_new_file()
	vim.ui.input({ prompt = "New file name: " }, function(input)
		if input and input ~= "" then
			vim.cmd("edit " .. vim.fn.fnameescape(input))
		end
	end)
end

-- Search and replace using Grug-Far with buffer filetype filter
function M.search_and_replace()
	local grug = require("grug-far")
	local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
	grug.open({
		transient = true,
		prefills = {
			filesFilter = ext and ext ~= "" and "*." .. ext or nil,
		},
	})
end

-- Go to previous Git hunk, using diff mode if active, else gitsigns
function M.prev_hunk()
	if vim.wo.diff then
		vim.cmd.normal({ "[c", bang = true })
	else
		require("gitsigns").nav_hunk("prev")
	end
end

-- Go to next Git hunk, using diff mode if active, else gitsigns
function M.next_hunk()
	if vim.wo.diff then
		vim.cmd.normal({ "]c", bang = true })
	else
		require("gitsigns").nav_hunk("next")
	end
end

-- Go to previous Trouble or Quickfix item depending on which is open
function M.prev_trouble_or_quickfix()
	if require("trouble").is_open() then
		-- @diagnostic disable-next-line: missing-parameter, missing-fields
		require("trouble").prev({ skip_groups = true, jump = true })
	else
		local ok, err = pcall(vim.cmd.cprev)
		if not ok then
			vim.notify(err, vim.log.levels.ERROR)
		end
	end
end

-- Go to next Trouble or Quickfix item depending on which is open
function M.next_trouble_or_quickfix()
	if require("trouble").is_open() then
		-- @diagnostic disable-next-line: missing-parameter, missing-fields
		require("trouble").next({ skip_groups = true, jump = true })
	else
		local ok, err = pcall(vim.cmd.cnext)
		if not ok then
			vim.notify(err, vim.log.levels.ERROR)
		end
	end
end

-- Format current buffer or visual selection using Conform
function M.format_buffer()
	require("conform").format({ async = true, lsp_format = "fallback" })
end

-- Start treesitter incremental selection using Flash
function M.flash_treesitter()
	require("flash").treesitter({
		actions = {
			["<c-space>"] = "next",
			["<BS>"] = "prev",
		},
	})
end

return M
