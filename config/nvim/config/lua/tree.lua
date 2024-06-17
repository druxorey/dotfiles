require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive"
    },
    view = {
        width = 30,
        side = 'right',
    },
    renderer = {
        group_empty = true
    },
    filters = {
        dotfiles = true
    },
    update_cwd = true,
})
