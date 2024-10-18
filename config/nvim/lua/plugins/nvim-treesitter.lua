return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {  
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = {
                "bash",
                "html",
                "javascript",
                "json",
				"rust",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "rasi",
                "typescript",
                "vim",
                "yaml",
            },
        },
    },
    {
        "Fymyte/rasi.vim",
        ft = 'rasi',
        lazy = true
    },
}
