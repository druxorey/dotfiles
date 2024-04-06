require("mason").setup()
require("mason-lspconfig").setup()
local lspconfig = require'lspconfig'
lspconfig.pyright.setup{}
lspconfig.html.setup{}
lspconfig.cssls.setup{}
lspconfig.gopls.setup{}
lspconfig.bashls.setup{}
lspconfig.clangd.setup{}
lspconfig.omnisharp_mono.setup{}
lspconfig.rust_analyzer.setup{}
lspconfig.vimls.setup{}
