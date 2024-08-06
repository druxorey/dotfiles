return {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    opts = {
        theme = "Dracula",
        no_window_controls = true,
        to_clipboard = true,

        output = function()
            local png_path = "~/Pictures/screenshots/code-screenshots/" .. os.date("!%Y-%m-%d_%H%M%S") .. "_code.png"
            local webp_path = png_path:gsub(".png$", ".webp")
            vim.schedule_wrap(function()
                os.execute("magick -quality 100 " .. png_path .. " " .. webp_path)
                os.execute("rm " .. png_path)
            end)()
            return png_path
        end,

        line_offset = function(args)
            return args.line1
        end
    }
}


