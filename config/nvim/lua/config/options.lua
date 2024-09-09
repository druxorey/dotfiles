-- Global options
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

-- Local options
local opt = vim.opt

-- File and buffer options
opt.autowrite = true
opt.undofile = true
opt.undolevels = 10000

-- Display options
opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.fillchars = {
    foldopen = "",
    foldclose = "",
    fold = " ",
    foldsep = " ",
    diff = "╱",
    eob = " "
}

-- Indentation options
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = false
opt.smartindent = true
opt.autoindent = true
opt.smarttab = true

-- Search options
opt.ignorecase = true
opt.smartcase = true
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- Interface options
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.confirm = true
opt.inccommand = "nosplit"
opt.jumpoptions = "view"
opt.laststatus = 300
opt.linebreak = true
opt.list = true
opt.mouse = "a"
opt.pumblend = 10
opt.pumheight = 10
opt.scrolloff = 4
opt.sessionoptions = {"buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds"}
opt.shiftround = true
opt.showmode = false
opt.sidescrolloff = 8
opt.spelllang = {"en", "es"}
opt.spelloptions:append("noplainbuffer")
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.statuscolumn = [[%!v:lua.require'lazyvim.util'.ui.statuscolumn()]]
opt.timeoutlen = vim.g.vscode and 1000 or 300
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.winminwidth = 5

-- Folding options
opt.foldlevel = 99
opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
opt.formatoptions = "jcroqlnt"
if vim.fn.has("nvim-0.10") == 1 then
    opt.smoothscroll = true
    opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
    opt.foldmethod = "expr"
    opt.foldtext = ""
else
    opt.foldmethod = "indent"
    opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
end

-- Other options
vim.g.autoformat = false
vim.g.markdown_recommended_style = 0
opt.updatetime = 200
opt.shortmess:append({
    W = true,
    I = true,
    c = true,
    C = true
})
