-- Remap escape
vim.keymap.set("n", "<C-c>", "<Esc>", { noremap = true, silent = true })

-- Usar alt + hjkl para redimensionar ventanas
vim.keymap.set("n", "<M-j>", ":resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-k>", ":resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-h>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-l>", ":vertical resize +2<CR>", { noremap = true, silent = true })

-- Manera alternativa de guardar
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-q>", ":wq!<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-b>", ":bd<CR>", { noremap = true, silent = true })

-- < o > para tabular
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })

-- shift + k/j para mover la línea seleccionada arriba/abajo
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", { noremap = true, silent = true })
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", { noremap = true, silent = true })

-- Usar Ctrl + hjkl para moverse entre ventanas
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- Neotree toggle
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })

-- Git vertical
vim.keymap.set("n", "<leader>gg", ":vertical Git<CR>", { noremap = true, silent = true, desc = "Git Changes" })

-- TAB para moverse al siguiente buffer, solo si no estamos en VSCode
if vim.g.vscode == nil then
	vim.keymap.set("n", "<TAB>", ":bnext<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<S-TAB>", ":bprevious<CR>", { noremap = true, silent = true })
end
