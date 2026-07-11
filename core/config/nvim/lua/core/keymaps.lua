-- ========================================================================== --
--
--
--          ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗
--          ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║
--          ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║
--          ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║
--          ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
--          ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
--
--                                  KEYMAPS
--                         https://github.com/druxorey
--
-- ========================================================================== --

local function get_root()
	local root = vim.fs.root(0, { ".git", "lua" })
	return root or vim.uv.cwd()
end

-- ================================= GENERAL ================================ --

-- Save file
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true, desc = "Save File" })

-- Escape and clear search highlight
vim.keymap.set({ "i", "n", "s" }, "<esc>", function()
	vim.cmd("noh")
	return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Delete single character without copying to register
vim.keymap.set("n", "x", '"_x', { noremap = true, silent = true })

-- Keep last yanked when pasting in Visual mode
vim.keymap.set("v", "p", '"_dP', { noremap = true, silent = true })

-- Increment/decrement numbers
vim.keymap.set("n", "+", "<C-a>", { desc = "Increment number" })
vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement number" })

-- Indent visual selection and preserve selection
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true, desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true, desc = "Indent right" })

-- Commenting helpers
vim.keymap.set("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment above" })
vim.keymap.set("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment below" })

-- Move selected lines up/down in Visual mode
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", { noremap = true, silent = true, desc = "Move block down" })
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", { noremap = true, silent = true, desc = "Move block up" })

-- =============================== NAVIGATION =============================== --

-- Search result navigation
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Find and center (Normal mode overrides)
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Page navigation (half screen)
vim.keymap.set("n", "<C-M-j>", "<C-d>", { noremap = true, silent = true, desc = "Page down (half screen)" })
vim.keymap.set("n", "<C-M-k>", "<C-u>", { noremap = true, silent = true, desc = "Page up (half screen)" })
vim.keymap.set("v", "<C-M-j>", "<C-d>", { noremap = true, silent = true, desc = "Page down (half screen)" })
vim.keymap.set("v", "<C-M-k>", "<C-u>", { noremap = true, silent = true, desc = "Page up (half screen)" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Go to right window" })

-- Window resizing
vim.keymap.set("n", "<M-h>", ":vertical resize -2<CR>", { noremap = true, silent = true, desc = "Decrease window width" })
vim.keymap.set("n", "<M-j>", ":resize -2<CR>", { noremap = true, silent = true, desc = "Decrease window height" })
vim.keymap.set("n", "<M-k>", ":resize +2<CR>", { noremap = true, silent = true, desc = "Increase window height" })
vim.keymap.set("n", "<M-l>", ":vertical resize +2<CR>", { noremap = true, silent = true, desc = "Increase window width" })

-- Buffer tabs navigation (if not in VSCode)
if vim.g.vscode == nil then
	vim.keymap.set("n", "<s-tab>", ":bprevious<CR>", { noremap = true, silent = true, desc = "Previous buffer" })
	vim.keymap.set("n", "<tab>", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
end

-- ============================ LEADER SUBGROUPS ============================ --

-- Buffer Management
vim.keymap.set("n", "<leader>bd", "<cmd>:bd<cr>", { desc = "Delete buffer and window" })
vim.keymap.set("n", "<leader>bi", function() require("snacks").bufdelete.invisible() end, { desc = "Delete invisible buffers" })
vim.keymap.set("n", "<leader>bo", function() require("snacks").bufdelete.other() end, { desc = "Delete other buffers" })
vim.keymap.set("n", "<C-b>", function() require("snacks").bufdelete() end, { desc = "Delete buffer" })

-- Tabpages Management
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
vim.keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })

-- Window splitting & maximize controls
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>ws", "<C-W>x", { desc = "Swap Current With Next", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
vim.keymap.set("n", "<leader>wm", function() require("snacks").toggle.zoom()() end, { desc = "Toggle Maximize Window" })

-- File Utilities & File Search (Telescope / Neo-tree / Terminal / Scratch)
vim.keymap.set("n", "<leader>e", function() require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() }) end, { desc = "Explorer (cwd)" })
vim.keymap.set("n", "<leader>E", function() require("neo-tree.command").execute({ toggle = true, dir = get_root() }) end, { desc = "Explorer (Root Dir)" })
vim.keymap.set("n", "<leader>t", "<CMD>FloatermNew<CR>", { desc = "Terminal" })
vim.keymap.set("n", "<leader>.", function() require("snacks").scratch() end, { desc = "Toggle Scratch Buffer" })
vim.keymap.set("n", "<leader>S", function() require("snacks").scratch.select() end, { desc = "Select Scratch Buffer" })
vim.keymap.set("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fx", function() require("telescope.builtin").find_files({ cwd = "~" }) end, { desc = "Telescope find files (Home Dir)" })
vim.keymap.set({ "n", "x" }, "<leader>fr", function()
	local grug = require("grug-far")
	local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
	grug.open({
		transient = true,
		prefills = {
			filesFilter = ext and ext ~= "" and "*." .. ext or nil,
		},
	})
end, { desc = "Search and Replace" })
vim.keymap.set("v", "<leader>fs", function() require("nvim-silicon").shoot() end, { desc = "Create code screenshot" })

-- Git Mappings (Fugitive / LazyGit / Telescope)
vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { noremap = true, silent = true, desc = "Git Commit (Fugitive)" })
vim.keymap.set("n", "<leader>gC", "<cmd>Telescope git_commits<CR>", { noremap = true, silent = true, desc = "Git Commits History" })
vim.keymap.set("n", "<leader>gg", ":vertical Git<CR>", { noremap = true, silent = true, desc = "Git Changes (Fugitive)" })
vim.keymap.set("n", "<leader>gl", function() require("snacks").lazygit({ cwd = get_root() }) end, { desc = "Lazygit (Root Dir)" })
vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { noremap = true, silent = true, desc = "Git Push (Fugitive)" })
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { noremap = true, silent = true, desc = "Git Status History" })
 vim.keymap.set("n", "<leader>gL", function() require("snacks").picker.git_log() end, { desc = "Git Log (cwd)" })
 vim.keymap.set("n", "<leader>gf", function() require("snacks").picker.git_log_file() end, { desc = "Git Current File History" })
vim.keymap.set({ "n", "x" }, "<leader>gB", function() require("snacks").gitbrowse() end, { desc = "Git Browse (open)" })

-- Git Hunks & Blame (Gitsigns)
vim.keymap.set("n", "<leader>ghb", function() require("gitsigns").blame_line({ full = true }) end, { desc = "Blame Line" })
vim.keymap.set("n", "<leader>ghB", function() require("gitsigns").blame() end, { desc = "Blame Buffer" })
vim.keymap.set("n", "<leader>ghd", function() require("gitsigns").diffthis() end, { desc = "Diff This" })
vim.keymap.set("n", "<leader>ghD", function() require("gitsigns").diffthis("~") end, { desc = "Diff This ~" })
vim.keymap.set("n", "<leader>ghp", function() require("gitsigns").preview_hunk_inline() end, { desc = "Preview Hunk Inline" })
vim.keymap.set("n", "<leader>ghP", function() require("gitsigns").preview_hunk() end, { noremap = true, silent = true, desc = "Git Preview Hunk (Gitsigns)" })
vim.keymap.set("n", "<leader>ghR", function() require("gitsigns").reset_buffer() end, { desc = "Reset Buffer" })
vim.keymap.set({ "n", "x" }, "<leader>ghr", function() require("gitsigns").reset_hunk() end, { desc = "Reset Hunk" })
vim.keymap.set("n", "<leader>ghS", function() require("gitsigns").stage_buffer() end, { desc = "Stage Buffer" })
vim.keymap.set({ "n", "x" }, "<leader>ghs", function() require("gitsigns").stage_hunk() end, { desc = "Stage Hunk" })

-- Session Management (Persistence)
vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Don't Save Current Session" })
vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore Last Session" })
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore Session" })
vim.keymap.set("n", "<leader>qS", function() require("persistence").select() end, { desc = "Select Session" })

-- Option toggles & Inspectors (Snacks Toggle)
vim.keymap.set("n", "<leader>oA", function() require("snacks").toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):toggle() end, { desc = "Toggle Tabline" })
vim.keymap.set("n", "<leader>ob", function() require("snacks").toggle.option("background", { off = "light", on = "dark" , name = "Dark Background" }):toggle() end, { desc = "Toggle Background Theme" })
vim.keymap.set("n", "<leader>od", function() require("snacks").toggle.diagnostics():toggle() end, { desc = "Toggle Diagnostics" })
vim.keymap.set("n", "<leader>oD", function() require("snacks").toggle.dim():toggle() end, { desc = "Toggle Dim Mode" })
vim.keymap.set("n", "<leader>og", function() require("snacks").toggle.indent():toggle() end, { desc = "Toggle Indent Guides" })
vim.keymap.set("n", "<leader>oh", function() require("snacks").toggle.inlay_hints():toggle() end, { desc = "Toggle Inlay Hints" })
vim.keymap.set("n", "<leader>oi", vim.show_pos, { desc = "Inspect Pos" })
vim.keymap.set("n", "<leader>oI", function() vim.treesitter.inspect_tree() vim.api.nvim_input("I") end, { desc = "Inspect Tree" })
vim.keymap.set("n", "<leader>ol", function() require("snacks").toggle.line_number():toggle() end, { desc = "Toggle Line Numbers" })
vim.keymap.set("n", "<leader>oL", function() require("snacks").toggle.option("relativenumber", { name = "Relative Number" }):toggle() end, { desc = "Toggle Relative Line Numbers" })
vim.keymap.set("n", "<leader>or", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Redraw / Clear hlsearch / Diff Update" })
vim.keymap.set("n", "<leader>oS", function() require("snacks").toggle.scroll():toggle() end, { desc = "Toggle Smooth Scroll" })
vim.keymap.set("n", "<leader>os", function() require("snacks").toggle.option("spell", { name = "Spelling" }):toggle() end, { desc = "Toggle Spelling" })
vim.keymap.set("n", "<leader>oT", function() require("snacks").toggle.treesitter():toggle() end, { desc = "Toggle Treesitter" })
vim.keymap.set("n", "<leader>ow", function() require("snacks").toggle.option("wrap", { name = "Wrap" }):toggle() end, { desc = "Toggle Wrap" })

-- Package Managers
vim.keymap.set("n", "<leader>oZ", "<cmd>Lazy<cr>", { desc = "Lazy" })
vim.keymap.set("n", "<leader>oM", "<cmd>Mason<cr>", { desc = "Mason" })

-- Miscellaneous Leader Mappings
vim.keymap.set("n", "<leader>?", function() require("which-key").show({ global = false }) end, { desc = "Buffer Keymaps (which-key)" })
vim.keymap.set("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- ============================ BRACKET MAPPINGS ============================ --

-- Git Hunk navigation (Gitsigns)
vim.keymap.set("n", "[h", function()
	if vim.wo.diff then
		vim.cmd.normal({ "[c", bang = true })
	else
		require("gitsigns").nav_hunk("prev")
	end
end, { desc = "Prev Hunk" })
vim.keymap.set("n", "]h", function()
	if vim.wo.diff then
		vim.cmd.normal({ "]c", bang = true })
	else
		require("gitsigns").nav_hunk("next")
	end
end, { desc = "Next Hunk" })

vim.keymap.set("n", "[H", function() require("gitsigns").nav_hunk("first") end, { desc = "First Hunk" })
vim.keymap.set("n", "]H", function() require("gitsigns").nav_hunk("last") end, { desc = "Last Hunk" })

-- Yanky put indentation adjustments
vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put Indented Before Cursor (Linewise)" })
vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put Indented After Cursor (Linewise)" })
vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put Indented Before Cursor (Linewise)" })
vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put Indented After Cursor (Linewise)" })

-- Yank history navigation
vim.keymap.set("n", "[y", "<Plug>(YankyCycleForward)", { desc = "Cycle Forward Through Yank History" })
vim.keymap.set("n", "]y", "<Plug>(YankyCycleBackward)", { desc = "Cycle Backward Through Yank History" })

-- Trouble & Quickfix list navigation
vim.keymap.set("n", "[q", function()
	if require("trouble").is_open() then
		---@diagnostic disable-next-line: missing-parameter, missing-fields
		require("trouble").prev({ skip_groups = true, jump = true })
	else
		local ok, err = pcall(vim.cmd.cprev)
		if not ok then vim.notify(err, vim.log.levels.ERROR) end
	end
end, { desc = "Previous Trouble/Quickfix Item" })
vim.keymap.set("n", "]q", function()
	if require("trouble").is_open() then
		---@diagnostic disable-next-line: missing-parameter, missing-fields
		require("trouble").next({ skip_groups = true, jump = true })
	else
		local ok, err = pcall(vim.cmd.cnext)
		if not ok then vim.notify(err, vim.log.levels.ERROR) end
	end
end, { desc = "Next Trouble/Quickfix Item" })

-- Todo comments navigation
vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous Todo Comment" })
vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next Todo Comment" })

-- ============================ PLUGIN MAPPINGS ============================= --

-- Trouble Diagnostics lists
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
vim.keymap.set("n", "<leader>xt", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", { desc = "Todo" })

-- Trouble Symbol & LSP lists
vim.keymap.set("n", "<leader>cX", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols (Trouble)" })
vim.keymap.set("n", "<leader>cS", "<cmd>Trouble lsp toggle<cr>", { desc = "LSP references/definitions/... (Trouble)" })

-- Conform formatting
vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { noremap = true, silent = true, desc = "Format buffer or selection" })

-- Flash Search & Selection
vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
vim.keymap.set({ "n", "o", "x" }, "<c-space>", function()
	require("flash").treesitter({
		actions = {
			["<c-space>"] = "next",
			["<BS>"] = "prev",
		},
	})
end, { desc = "Treesitter Incremental Selection" })
vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "o", "x" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })

-- Yanky put/yank operators
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put Text Before Cursor" })
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put Text After Cursor" })
vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)", { desc = "Yank Text" })
vim.keymap.set({ "n", "x" }, "<leader>p", function() require("telescope").extensions.yank_history.yank_history({}) end, { desc = "Open Yank History" })

-- =============================== AUTOCMDS ================================ --

-- Register LSP keymaps automatically when a server attaches to a buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(ev)
		local opts = { buffer = ev.buf }

		-- Navigation & documentation
		vim.keymap.set("n", "[[", function() require("snacks").words.jump(-vim.v.count1) end, vim.tbl_extend("force", opts, { desc = "Prev Reference" }))
		vim.keymap.set("n", "]]", function() require("snacks").words.jump(vim.v.count1) end, vim.tbl_extend("force", opts, { desc = "Next Reference" }))
		vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Goto Definition" }))
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Goto Declaration" }))
		vim.keymap.set("n", "gI", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Goto Implementation" }))
		vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))
		vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Goto References", nowait = true }))
		vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Goto Type Definition" }))
		vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))

		-- Code actions, rename and diagnostics
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
		vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Line Diagnostics" }))
		vim.keymap.set("n", "<leader>cL", "<cmd>LspInfo<CR>", vim.tbl_extend("force", opts, { desc = "Lsp Info" }))
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
	end,
})

-- Run Lua script (only in Lua files)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function(ev)
		vim.keymap.set({ "n", "x" }, "<localleader>r", function() require("snacks").debug.run() end, { buffer = ev.buf, desc = "Run Lua" })
	end,
})

-- Compile LaTex file
vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function()
		vim.keymap.set("n", "<localleader>lc", "<cmd>VimtexCompile<CR>", { noremap = true, silent = true, desc = "LaTeX Compile" })
		vim.keymap.set("n", "<localleader>ls", "<cmd>VimtexStop<CR>", { noremap = true, silent = true, desc = "LaTeX Stop" })
		vim.keymap.set("n", "<localleader>lv", "<cmd>VimtexView<CR>", { noremap = true, silent = true, desc = "LaTeX View" })
	end,
})

vim.keymap.set('n', 'gt', "<CMD>TSJToggle<CR>", { desc = "Toggle Node Under Cursor" })
vim.keymap.set('n', 'gT', "<CMD>TSJToggle<CR>", { desc = "which_key_ignore" })
