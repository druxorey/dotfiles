vim.api.nvim_create_autocmd("FileType", {
    pattern = "csv",
    callback = function()
        vim.cmd("CsvViewEnable")
    end,
})
