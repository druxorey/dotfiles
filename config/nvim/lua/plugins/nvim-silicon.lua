return {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    opts = {
        theme = "Dracula",
        no_window_controls = true,
        to_clipboard = true,

        output = function()
            return "~/Pictures/screenshots/code-screenshots/" .. os.date("!%Y-%m-%d_%H%M%S") .. "_code.png"
        end,

        line_offset = function(args)
            return args.line1
        end
    }
}
