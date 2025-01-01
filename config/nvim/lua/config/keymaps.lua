
-- ======================================================================#
--
--
--		  ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗
--		  ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║
--		  ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║
--		  ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║
--		  ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
--		  ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
--
--
-- ======================================================================#

--* ============================ general =========================== *--

-- Remap escape
vim.keymap.set("n", "<C-c>", "<Esc>", { noremap = true, silent = true })

-- Use alt + hjkl to resize windows
vim.keymap.set("n", "<M-j>", ":resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-k>", ":resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-h>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-l>", ":vertical resize +2<CR>", { noremap = true, silent = true })

-- Alternative way to save
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-q>", ":wq!<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-b>", ":bd<CR>", { noremap = true, silent = true })

-- < or > to indent
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })

-- shift + k/j to move the selected line up/down
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", { noremap = true, silent = true })
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", { noremap = true, silent = true })

-- Use Ctrl + hjkl to move between windows
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

--* ==================== pluggins configurations =================== *--

-- Neotree toggle
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })

-- Copilot Chat toggle
vim.keymap.set("n", "<leader>ai", ":CopilotChat<CR>", { noremap = true, silent = true, desc = "Open Copilot Chat"})
vim.keymap.set("v", "<leader>ai", ":'<,'>CopilotChat<CR>", { noremap = true, silent = true, desc = "Open Copilot Chat" })

-- Silicon toggle
vim.keymap.set("v", "<leader>si", ":'<,'>Silicon<CR>", { noremap = true, silent = true, desc = "Take a screenshot" })

-- Git
vim.keymap.set("n", "<leader>gg", ":vertical Git<CR>", { noremap = true, silent = true, desc = "Git Changes" })
vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { noremap = true, silent = true, desc = "Git Commits" })
vim.keymap.set("n", "<leader>gs", ":Git status<CR>", { noremap = true, silent = true, desc = "Git Status" })
vim.keymap.set("n", "<leader>gl", ":Git log<CR>", { noremap = true, silent = true, desc = "Git Log" })
vim.keymap.set("n", "<leader>gC", "<cmd>FzfLua git_commits<CR>", { noremap = true, silent = true, desc = "Git Commits History" })
vim.keymap.set("n", "<leader>gS", "<cmd>FzfLua git_status<CR>", { noremap = true, silent = true, desc = "Git Status History" })
vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { noremap = true, silent = true, desc = "Git Preview Hunk" })

-- TAB to move to the next buffer
if vim.g.vscode == nil then
	vim.keymap.set("n", "<TAB>", ":bnext<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<S-TAB>", ":bprevious<CR>", { noremap = true, silent = true })
end

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files , { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fx', function()
	builtin.find_files({ cwd = '~' })
end, { desc = 'Telescope find files (Home Dir)' })
