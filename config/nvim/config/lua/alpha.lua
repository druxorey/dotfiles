require'alpha'.setup(require'alpha.themes.theta'.config)

local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowPink",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local hooks = require "ibl.hooks"
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#89383f" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#828754" })
    vim.api.nvim_set_hl(0, "RainbowPink", { fg = "#89476f" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#896547" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#35874d" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#675389" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#4e7e8b" })
end)

require("ibl").setup { indent = { highlight = highlight } }
