
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
--                                  OPTIONS
--                         https://github.com/druxorey
--
-- ========================================================================== --

local gen = vim.g
local opt = vim.opt

-- ============================= global options ============================= --

gen.mapleader = " "                                                -- Set leader key to space
gen.maplocalleader = "\\"                                          -- Set local leader key to backslash
gen.lazyvim_picker = "auto"                                        -- Picker to use (auto, telescope, fzf)
gen.lazyvim_cmp = "auto"                                           -- Completion engine to use (auto, nvim-cmp, blink.cmp)
gen.ai_cmp = false                                                 -- Use Ai completion source instead of inline suggestions if supported
gen.root_spec = { "lsp", { ".git", "lua" }, "cwd" }                -- List of detectors for project root detection
gen.root_lsp_ignore = { "copilot" }                                -- Ignore these LSP servers for root detection
gen.lazygit_config = true                                          -- Setup lazygit config automatically
gen.deprecation_warnings = false                                   -- Hide deprecation warnings
gen.trouble_lualine = true                                         -- Enable Trouble status line component integration in lualine
gen.bigfile_size = 1024 * 1024 * 1.5                               -- Big file size threshold (1.5 MB)
gen.markdown_recommended_style = 0                                 -- Disable recommended style settings for markdown to prevent custom indentation override

-- ============================= file and buffer ============================ --

opt.autowrite = true                                               -- Enable auto write to save buffers automatically on actions like :next
opt.undofile = true                                                -- Save undo history to a file
opt.undolevels = 10000                                             -- Maximum number of changes that can be undone

-- ================================= display ================================ --

opt.cursorline = true                                              -- Enable highlighting of the current line
opt.number = true                                                  -- Print line numbers
opt.relativenumber = true                                          -- Relative line numbers
opt.signcolumn = "yes"                                             -- Always show the signcolumn to prevent layout shifts
opt.termguicolors = true                                           -- True color support in the terminal
opt.ruler = false                                                  -- Disable the default ruler since we have a statusline
opt.wrap = false                                                   -- Disable line wrap by default
opt.showtabline = 0                                                -- Disable tabline (top bar)
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = "~"
}

-- =============================== indentation ============================== --

opt.tabstop = 4                                                    -- Number of spaces that a Tab in the file counts for
opt.shiftwidth = 4                                                 -- Number of spaces to use for each step of (auto)indent
opt.expandtab = false                                              -- Do not expand tabs to spaces (use actual tabs)
opt.smartindent = true                                             -- Insert indents automatically in appropriate locations
opt.autoindent = true                                              -- Copy indent from current line when starting a new line
opt.smarttab = true                                                -- Make tab inserting behave smarter with spaces/tabs

-- ================================= search ================================= --

opt.ignorecase = true                                              -- Ignore case in search patterns
opt.smartcase = true                                               -- Override ignorecase if search pattern contains uppercase characters
opt.grepformat = "%f:%l:%c:%m"                                     -- Format of the grep output
opt.grepprg = "rg --vimgrep"                                       -- Use ripgrep for grepping

-- ================================ interface ================================ --

opt.clipboard = "unnamedplus"                                      -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"                          -- Options for insert mode completion
opt.confirm = true                                                 -- Confirm to save changes before exiting modified buffer
opt.inccommand = "nosplit"                                         -- Show incremental search/replace preview in a split window
opt.jumpoptions = "view"                                           -- Keep current view when jumping through changelist/jumplist
opt.laststatus = 3                                                 -- Global statusline (1 statusline for all windows instead of one per window)
opt.linebreak = true                                               -- Wrap lines at convenient characters instead of in the middle of words
opt.list = true                                                    -- Show listchars (like tabs, trail spaces, etc.)
opt.mouse = "a"                                                    -- Enable mouse support in all modes
opt.pumblend = 10                                                  -- Popup menu blend (transparency)
opt.pumheight = 10                                                 -- Maximum number of entries in the popup menu
opt.scrolloff = 4                                                  -- Minimum number of screen lines to keep above and below the cursor
opt.sessionoptions = { "buffers", "curdir", "tabpages",            -- Session settings
					   "winsize", "help", "globals",
					   "skiprtp", "folds" }
opt.shiftround = true                                              -- Round indent to multiple of shiftwidth
opt.showmode = false                                               -- Do not show mode in status line (since statusline handles it)
opt.sidescrolloff = 8                                              -- Minimum number of screen columns to keep to the left and right of cursor
opt.spelllang = { "en", "es" }                                     -- Spelling dictionaries (English and Spanish)
opt.spelloptions:append("noplainbuffer")                           -- Do not spellcheck in plain text buffers
opt.splitbelow = true                                              -- Put new windows below current window
opt.splitkeep = "screen"                                           -- Keep the same screen lines when splitting windows
opt.splitright = true                                              -- Put new windows right of current window
opt.timeoutlen = vim.g.vscode and 1000 or 300                      -- Timeout for mapped sequences (quick which-key trigger)
opt.virtualedit = "block"                                          -- Allow cursor to move past end of line in visual block mode
opt.wildmode = "longest:full,full"                                 -- Command-line completion mode settings
opt.winminwidth = 5                                                -- Minimum window width

-- ================================= folding ================================ --

opt.foldlevel = 99                                                 -- Open all folds by default
opt.formatoptions = "jcroqlnt"                                     -- Formatting behavior settings (e.g. autowrap comments)
opt.smoothscroll = true                                            -- Smooth scrolling on wrapped lines
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"                   -- Treesitter folding expression
opt.foldmethod = "expr"                                            -- Fold based on expression
opt.foldtext = ""                                                  -- Standard empty foldtext (modern Neovim styling)
opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]  -- Use Snacks.statuscolumn for a modern diagnostics + fold + line number column

-- ================================== other ================================= --

opt.updatetime = 200                                               -- Timeout after which swap file is written and CursorHold triggers
opt.shortmess:append({
	W = true,                                                      -- Do not give "written" message when writing a file
	I = true,                                                      -- Do not give the intro message when starting Neovim
	c = true,                                                      -- Do not pass messages to ins-completion-menu
	C = true                                                       -- Do not show messages in completion menu
})
