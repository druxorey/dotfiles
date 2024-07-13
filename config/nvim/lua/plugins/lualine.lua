return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
        options = {
            icons_enabled = true,
            theme = "dracula",
            component_separators = "",
            section_separators = {
                left = "",
                right = ""
            },
            disabled_filetypes = {
                statusline = {"neo-tree"},
                winbar = {"neo-tree"}
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = false,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000
            }
        },
        sections = {
            lualine_a = {{
                "mode",
                separator = {
                    left = "",
                    right = ""
                },
                right_padding = 2
            }},
            lualine_b = {"branch", "diff", "diagnostics"},
            lualine_c = {"%=", "filename"},
            lualine_x = {"encoding"},
            lualine_y = {"filetype", "filesize"},
            lualine_z = {{
                "location",
                separator = {
                    left = "",
                    right = ""
                },
                left_padding = 2
            }}
        },
        inactive_sections = {
            lualine_a = {{
                "mode",
                separator = {
                    left = "",
                    right = ""
                },
                right_padding = 2
            }},
            lualine_b = {"branch", "diff", "diagnostics"},
            lualine_c = {"%=", "filename"},
            lualine_x = {},
            lualine_y = {"filetype", "filesize"},
            lualine_z = {{
                "location",
                separator = {
                    left = "",
                    right = ""
                },
                left_padding = 2
            }}
        },
        winbar = {},
        inactive_winbar = {},
        extensions = {}
    }
}
