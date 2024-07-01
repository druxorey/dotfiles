require("mason").setup()
require("mason-lspconfig").setup()

local lspconfig = require'lspconfig'

lspconfig.pyright.setup{
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true
            }
        }
    }
}
lspconfig.html.setup{}
lspconfig.gopls.setup{
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
}
lspconfig.bashls.setup{}
lspconfig.clangd.setup{}
lspconfig.rust_analyzer.setup{
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importMergeBehavior = "last",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true,
            },
            procMacro = {
                enable = true,
            },
        },
    },
}
lspconfig.vimls.setup{}
