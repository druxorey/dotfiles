vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.lazyvim_picker = "auto"
vim.g.root_spec = {"lsp", {".git", "lua"}, "cwd"}
vim.g.lazygit_config = true

vim.g.lazyvim_statuscolumn = {
    folds_open = false,
    folds_githl = false
}

vim.g.deprecation_warnings = false
vim.g.bigfile_size = 1024 * 1024 * 1.5
vim.g.trouble_lualine = true

local opt = vim.opt

opt.autowrite = true
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.fillchars = {
    foldopen = "",
    foldclose = "",
    fold = " ",
    foldsep = " ",
    diff = "╱",
    eob = " "
}
opt.foldlevel = 99
opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
opt.formatoptions = "jcroqlnt"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.jumpoptions = "view"
opt.laststatus = 300
opt.linebreak = true
opt.list = true
opt.mouse = "a"
opt.number = true
opt.pumblend = 10
opt.pumheight = 10
opt.relativenumber = true
opt.scrolloff = 4
opt.sessionoptions = {"buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds"}
opt.shiftround = true
opt.shiftwidth = 4
opt.shortmess:append({
    W = true,
    I = true,
    c = true,
    C = true
})
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.spelllang = {"en", "es"}
opt.spelloptions:append("noplainbuffer")
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.statuscolumn = [[%!v:lua.require'lazyvim.util'.ui.statuscolumn()]]
opt.termguicolors = true
opt.timeoutlen = vim.g.vscode and 1000 or 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.smartindent = true
opt.autoindent = true
opt.expandtab = true
opt.smarttab = true
opt.tabstop = 4

if vim.fn.has("nvim-0.10") == 1 then
    opt.smoothscroll = true
    opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
    opt.foldmethod = "expr"
    opt.foldtext = ""
else
    opt.foldmethod = "indent"
    opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
end

vim.g.autoformat = false
vim.g.markdown_recommended_style = 0
