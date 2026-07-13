
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

pcall(vim.keymap.del, "n", "gra")
pcall(vim.keymap.del, "n", "gri")
pcall(vim.keymap.del, "n", "grn")
pcall(vim.keymap.del, "n", "grr")
pcall(vim.keymap.del, "n", "grt")
pcall(vim.keymap.del, "n", "grx")

-- ================================= GENERAL ================================ --

-- Save file
vim.keymap.set("n", "<C-s>", "<cmd>w<cr>", { noremap = true, silent = true, desc = "Save File" })

-- Escape and clear search highlight
vim.keymap.set({ "i", "n", "s" }, "<esc>", function() return require("utils.keymaps").escape_and_clear() end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Delete single character without copying to register
vim.keymap.set("n", "x", '"_x', { noremap = true, silent = true })

-- Keep last yanked when pasting in Visual mode
vim.keymap.set("v", "p", '"_dP', { noremap = true, silent = true })

-- Increment/decrement
vim.keymap.set("n", "+", function() return require("dial.map").inc_normal() end, { expr = true, desc = "Increment" })
vim.keymap.set("n", "-", function() return require("dial.map").dec_normal() end, { expr = true, desc = "Decrement" })
vim.keymap.set("v", "+", function() return require("dial.map").inc_visual() end, { expr = true, desc = "Increment" })
vim.keymap.set("v", "-", function() return require("dial.map").dec_visual() end, { expr = true, desc = "Decrement" })

-- Indent visual selection and preserve selection
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true, desc = "Indent Left" })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true, desc = "Indent Right" })

-- Commenting helpers
vim.keymap.set("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })
vim.keymap.set("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment Below" })

-- Move selected lines up/down in Visual mode
vim.keymap.set("x", "J", ":move '>+1<cr>gv-gv", { noremap = true, silent = true, desc = "Move Block Down" })
vim.keymap.set("x", "K", ":move '<-2<cr>gv-gv", { noremap = true, silent = true, desc = "Move Block Up" })

vim.keymap.set("n", "<leader>e", function() require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() }) end, { desc = "Explorer (cwd)" })
vim.keymap.set("n", "<leader>E", function() require("neo-tree.command").execute({ toggle = true, dir = get_root() }) end, { desc = "Explorer (Root Dir)" })
vim.keymap.set("n", "<leader>.", function() require("snacks").scratch() end, { desc = "Scratch Buffer" })
vim.keymap.set({ "n", "x" }, "<leader>p", function() require("telescope").extensions.yank_history.yank_history({}) end, { desc = "Open Yank History" })

-- =============================== NAVIGATION =============================== --

-- Search result navigation
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Find and center (Normal mode overrides)
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Page navigation (half screen)
vim.keymap.set("n", "<C-M-j>", "<C-d>", { noremap = true, silent = true, desc = "Page Down (Half Screen)" })
vim.keymap.set("n", "<C-M-k>", "<C-u>", { noremap = true, silent = true, desc = "Page Up (Half Screen)" })
vim.keymap.set("v", "<C-M-j>", "<C-d>", { noremap = true, silent = true, desc = "Page Down (Half Screen)" })
vim.keymap.set("v", "<C-M-k>", "<C-u>", { noremap = true, silent = true, desc = "Page Up (Half Screen)" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Go to Left Window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Go to Lower Window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Go to Upper Window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Go to right Window" })

-- Window resizing
vim.keymap.set("n", "<M-l>", "<cmd>vertical resize +2<cr>", { noremap = true, silent = true, desc = "Increase Window Width" })
vim.keymap.set("n", "<M-h>", "<cmd>vertical resize -2<cr>", { noremap = true, silent = true, desc = "Decrease Window Width" })
vim.keymap.set("n", "<M-k>", "<cmd>resize +2<cr>", { noremap = true, silent = true, desc = "Increase Window Height" })
vim.keymap.set("n", "<M-j>", "<cmd>resize -2<cr>", { noremap = true, silent = true, desc = "Decrease wIndow Height" })

-- Buffer tabs navigation (if not in VSCode)
if vim.g.vscode == nil then
	vim.keymap.set("n", "<s-tab>", "<cmd>bprevious<cr>", { noremap = true, silent = true, desc = "Previous Buffer" })
	vim.keymap.set("n", "<tab>", "<cmd>bnext<cr>", { noremap = true, silent = true, desc = "Next Buffer" })
end

-- ============================ LEADER SUBGROUPS ============================ --

-- Buffer Management
vim.keymap.set("n", "<leader>bd", function() require("snacks").bufdelete() end, { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>bi", function() require("snacks").bufdelete.invisible() end, { desc = "Delete Invisible Buffers" })
vim.keymap.set("n", "<leader>bo", function() require("snacks").bufdelete.other() end, { desc = "Delete Other Buffers" })
vim.keymap.set("n", "<leader>bD", "<cmd>bd<cr>", { desc = "Delete Buffer and Window" })

-- Code / LSP Management
vim.keymap.set("n", "<leader>cx", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols" })
vim.keymap.set("n", "<leader>cd", function() require("neogen").generate() end, { desc = "Doc Annotation" })
vim.keymap.set("v", "<leader>cs", function() require("nvim-silicon").shoot() end, { desc = "Screenshot Code" })
vim.keymap.set("n", "<leader>cS", "<cmd>Trouble lsp toggle<cr>", { desc = "LSP References & Definitions" })
vim.keymap.set({ "n", "v" }, "<leader>cf", function() require("utils.keymaps").format_buffer() end, { noremap = true, silent = true, desc = "Format Buffer or Selection" })

-- File Utilities & File Search
vim.keymap.set("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Find Buffer" })
vim.keymap.set("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Find File" })
vim.keymap.set("n", "<leader>fF", function() require("telescope.builtin").find_files({ cwd = "~" }) end, { desc = "Find File (Home Dir)" })
vim.keymap.set("n", "<leader>fr", function() require("telescope.builtin").oldfiles() end, { desc = "Find Recent" })
vim.keymap.set("n", "<leader>fn", function() require("utils.keymaps").create_new_file() end, { desc = "Create New File" })

-- AI Assistant Mappings
vim.keymap.set({ "n", "x" }, "<leader>i", function() require("utils.ai").ask_ai() end, { desc = "Ask Ai" })
vim.keymap.set("n", "<leader>gC", function() require("utils.git_ai").git_ai_commit() end, { desc = "Generate Ai Commit" })
vim.keymap.set("n", "<leader>gB", function() require("utils.git_ai").git_ai_branch() end, { desc = "Generate Ai Branch" })

-- Git Mappings
vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<cr>", { noremap = true, silent = true, desc = "Git Commit" })
vim.keymap.set("n", "<leader>gl", "<cmd>Telescope git_commits<cr>", { noremap = true, silent = true, desc = "Git Logs" })
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gp", "<cmd>Git push<cr>", { noremap = true, silent = true, desc = "Git Push" })
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { noremap = true, silent = true, desc = "Git Status" })
vim.keymap.set("n", "<leader>gf", function() require("snacks").picker.git_log_file() end, { desc = "Git Current File History" })
vim.keymap.set({ "n", "x" }, "<leader>gb", function() require("snacks").gitbrowse() end, { desc = "Git Browse" })

-- Git Ai, Hunks & Blame
vim.keymap.set("n", "<leader>ghb", function() require("gitsigns").blame_line({ full = true }) end, { desc = "Blame Line" })
vim.keymap.set("n", "<leader>ghB", function() require("gitsigns").blame() end, { desc = "Blame Buffer" })
vim.keymap.set("n", "<leader>ghd", function() require("gitsigns").diffthis() end, { desc = "Diff This" })
vim.keymap.set("n", "<leader>ghD", function() require("gitsigns").diffthis("~") end, { desc = "Diff This ~" })
vim.keymap.set("n", "<leader>ghp", function() require("gitsigns").preview_hunk_inline() end, { desc = "Preview Hunk Inline" })
vim.keymap.set("n", "<leader>ghP", function() require("gitsigns").preview_hunk() end, { noremap = true, silent = true, desc = "Git Preview Hunk (Gitsigns)" })
vim.keymap.set("n", "<leader>ghR", function() require("gitsigns").reset_buffer() end, { desc = "Reset Buffer" })
vim.keymap.set("n", "<leader>ghS", function() require("gitsigns").stage_buffer() end, { desc = "Stage Buffer" })
vim.keymap.set({ "n", "x" }, "<leader>ghr", function() require("gitsigns").reset_hunk() end, { desc = "Reset Hunk" })
vim.keymap.set({ "n", "x" }, "<leader>ghs", function() require("gitsigns").stage_hunk() end, { desc = "Stage Hunk" })

-- Harpoon Mappings
vim.keymap.set("n", "<leader>ha", function() require("harpoon"):list():add() end, { desc = "Harpoon Add File" })
vim.keymap.set("n", "<leader>he", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, { desc = "Harpoon Toggle Menu" })
vim.keymap.set("n", "<leader>h1", function() require("harpoon"):list():select(1) end, { desc = "Harpoon File 1" })
vim.keymap.set("n", "<leader>h2", function() require("harpoon"):list():select(2) end, { desc = "Harpoon File 2" })
vim.keymap.set("n", "<leader>h3", function() require("harpoon"):list():select(3) end, { desc = "Harpoon File 3" })
vim.keymap.set("n", "<leader>h4", function() require("harpoon"):list():select(4) end, { desc = "Harpoon File 4" })
vim.keymap.set("n", "<leader>hp", function() require("harpoon"):list():prev() end, { desc = "Harpoon Prev File" })
vim.keymap.set("n", "<leader>hn", function() require("harpoon"):list():next() end, { desc = "Harpoon Next File" })

-- Session Management
vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Don't Save Current Session" })
vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore Last Session" })
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore Session" })
vim.keymap.set("n", "<leader>qS", function() require("persistence").select() end, { desc = "Select Session" })

-- Search Mappings
vim.keymap.set("n", "<leader>sg", function() require("telescope.builtin").live_grep() end, { desc = "Search Live Grep" })
vim.keymap.set("n", "<leader>sb", function() require("telescope.builtin").live_grep({ grep_open_files = true }) end, { desc = "Search in Open Buffers" })
vim.keymap.set("n", "<leader>sh", function() require("telescope.builtin").help_tags() end, { desc = "Search Help Tags" })
vim.keymap.set("n", "<leader>sk", function() require("telescope.builtin").keymaps() end, { desc = "Search Keymaps" })
vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Search TODOs" })
vim.keymap.set({ "n", "x" }, "<leader>sr", function() require("utils.keymaps").search_and_replace() end, { desc = "Search and Replace" })
vim.keymap.set("n", "<leader>sw", function() require("telescope.builtin").grep_string() end, { desc = "Search Word under Cursor" })
vim.keymap.set("v", "<leader>ss", function() require("telescope.builtin").grep_string() end, { desc = "Search Selection" })
vim.keymap.set("n", "<leader>ss", function() require("telescope.builtin").current_buffer_fuzzy_find() end, { desc = "Fuzzy Find Current File" })
vim.keymap.set("n", "<leader>sd", function() require("telescope.builtin").diagnostics() end, { desc = "Search Diagnostics" })

-- Tabpages Management
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
vim.keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })

-- Terminal Mappings
vim.keymap.set("n", "<leader>tN", "<cmd>FloatermNew<cr>", { desc = "Open New Terminal" })
vim.keymap.set("n", "<leader>tt", "<cmd>FloatermToggle<cr>", { desc = "Toggle Terminal Window" })
vim.keymap.set("n", "<leader>tp", "<cmd>FloatermPrev<cr>", { desc = "Previous Terminal" })
vim.keymap.set("n", "<leader>tn", "<cmd>FloatermNext<cr>", { desc = "Next Terminal" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n><cmd>FloatermToggle<cr>", { desc = "Toggle Terminal Window" })

-- Option toggles & Inspectors (Snacks Toggle)
vim.keymap.set("n", "<leader>ua", function() require("snacks").toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):toggle() end, { desc = "Toggle Tabline" })
vim.keymap.set("n", "<leader>ud", function() require("snacks").toggle.diagnostics():toggle() end, { desc = "Toggle Diagnostics" })
vim.keymap.set("n", "<leader>uD", function() require("snacks").toggle.dim():toggle() end, { desc = "Toggle Dim Mode" })
vim.keymap.set("n", "<leader>ug", function() require("snacks").toggle.indent():toggle() end, { desc = "Toggle Indent Guides" })
vim.keymap.set("n", "<leader>uh", function() require("snacks").toggle.inlay_hints():toggle() end, { desc = "Toggle Inlay Hints" })
vim.keymap.set("n", "<leader>ul", function() require("snacks").toggle.line_number():toggle() end, { desc = "Toggle Line Numbers" })
vim.keymap.set("n", "<leader>uL", function() require("snacks").toggle.option("relativenumber", { name = "Relative Number" }):toggle() end, { desc = "Toggle Relative Line Numbers" })
vim.keymap.set("n", "<leader>ur", "<cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><cr>", { desc = "Redraw Screen" })
vim.keymap.set("n", "<leader>us", function() require("snacks").toggle.option("spell", { name = "Spelling" }):toggle() end, { desc = "Toggle Spelling" })
vim.keymap.set("n", "<leader>uS", function() require("snacks").toggle.scroll():toggle() end, { desc = "Toggle Smooth Scroll" })
vim.keymap.set("n", "<leader>ut", function() require("snacks").toggle.treesitter():toggle() end, { desc = "Toggle Treesitter" })
vim.keymap.set("n", "<leader>uw", function() require("snacks").toggle.option("wrap", { name = "Wrap" }):toggle() end, { desc = "Toggle Wrap" })
vim.keymap.set("n", "<leader>uc", "<cmd>CsvViewToggle<cr>", { desc = "Toggle CSV View" })

-- Window splitting & maximize controls
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split Window Horizontal", remap = true })
vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split Window Vertical", remap = true })
vim.keymap.set("n", "<leader>ws", "<C-W>x", { desc = "Swap Current With Next", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
vim.keymap.set("n", "<leader>wm", function() require("snacks").toggle.zoom()() end, { desc = "Toggle Maximize Window" })

-- Trouble Lists & Diagnostics (Additional)
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>xt", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", { desc = "Todo" })

-- Miscellaneous Leader Mappings
vim.keymap.set("n", "<leader>?", function() require("which-key").show({ global = false }) end, { desc = "Keymaps (which-key)" })
vim.keymap.set("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })


-- ============================ BRACKET MAPPINGS ============================ --

-- Git Hunk navigation (Gitsigns)
vim.keymap.set("n", "[h", function() require("utils.keymaps").prev_hunk() end, { desc = "Prev Hunk" })
vim.keymap.set("n", "]h", function() require("utils.keymaps").next_hunk() end, { desc = "Next Hunk" })
vim.keymap.set("n", "[H", function() require("gitsigns").nav_hunk("first") end, { desc = "First Hunk" })
vim.keymap.set("n", "]H", function() require("gitsigns").nav_hunk("last") end, { desc = "Last Hunk" })

-- Trouble & Quickfix list navigation
vim.keymap.set("n", "[q", function() require("utils.keymaps").prev_trouble_or_quickfix() end, { desc = "Previous Trouble/Quickfix Item" })
vim.keymap.set("n", "]q", function() require("utils.keymaps").next_trouble_or_quickfix() end, { desc = "Next Trouble/Quickfix Item" })

-- Yank history navigation
vim.keymap.set("n", "[y", "<Plug>(YankyCycleForward)", { desc = "Cycle Forward Through Yank History" })
vim.keymap.set("n", "]y", "<Plug>(YankyCycleBackward)", { desc = "Cycle Backward Through Yank History" })

-- Yanky put indentation adjustments
vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put Indented Before Cursor (Linewise)" })
vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put Indented After Cursor (Linewise)" })
vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put Indented Before Cursor (Linewise)" })
vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put Indented After Cursor (Linewise)" })

-- Todo comments navigation
vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous Todo Comment" })
vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next Todo Comment" })


-- ============================ PLUGIN MAPPINGS ============================= --

-- Flash Search & Selection
vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
vim.keymap.set({ "n", "o", "x" }, "<c-space>", function() require("utils.keymaps").flash_treesitter() end, { desc = "Treesitter Incremental Selection" })
vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "o", "x" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })

-- Yanky put/yank operators
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put Text Before Cursor" })
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put Text After Cursor" })
vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)", { desc = "Yank Text" })

-- TSJToggle (Tree-sitter Join/Split)
vim.keymap.set("n", "gt", "<cmd>TSJToggle<cr>", { desc = "Toggle Node Under Cursor" })
vim.keymap.set("n", "gT", "<cmd>TSJToggle<cr>", { desc = "which_key_ignore" })

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
		vim.keymap.set("n", "gI", function() require("telescope.builtin").lsp_implementations() end, vim.tbl_extend("force", opts, { desc = "Goto Implementation" }))
		vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))
		vim.keymap.set("n", "gr", function() require("telescope.builtin").lsp_references() end, vim.tbl_extend("force", opts, { desc = "Goto References" }))
		vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Goto Type Definition" }))
		vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))

		-- Code actions, rename and diagnostics
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
		vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Line Diagnostics" }))
		vim.keymap.set("n", "<leader>cL", "<cmd>LspInfo<cr>", vim.tbl_extend("force", opts, { desc = "Lsp Info" }))
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
		vim.keymap.set("n", "<localleader>lc", "<cmd>VimtexCompile<cr>", { noremap = true, silent = true, desc = "LaTeX Compile" })
		vim.keymap.set("n", "<localleader>ls", "<cmd>VimtexStop<cr>", { noremap = true, silent = true, desc = "LaTeX Stop" })
		vim.keymap.set("n", "<localleader>lv", "<cmd>VimtexView<cr>", { noremap = true, silent = true, desc = "LaTeX View" })
	end,
})
