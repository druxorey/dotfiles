local bufferline = require('bufferline')
bufferline.setup({
    options = {
        theme = 'dracula',
        separator_style = {' ', ' '},
        indicator = {
            icon = '',
            style = 'icon'
        },
        offsets = {{
            filetype = "NvimTree",
            text = "NvimTree",
            padding = 1
        }},
        show_buffer_icons = true,
        style_preset = bufferline.style_preset.no_italic,
        style_preset = {bufferline.style_preset.no_italic, bufferline.style_preset.no_bold}
    },
    highlights = {
        fill = {
            bg = 'none'
        },
        background = {
            fg = '#F8F8F2',
            bg = '#44475A'
        },
        close_button = {
            fg = '#F8F8F2',
            bg = '#44475A'
        },
        close_button_selected = {
            fg = '#282A36',
            bg = '#BD93F9'
        },
        buffer_selected = {
            fg = '#44475A',
            bg = '#BD93F9'
        },
        separator = {
            fg = '#44475A',
            bg = 'none'
        },
        indicator_selected = {
            fg = '#BD93F9',
            bg = 'none'
        },
        close_button_visible = {
            fg = '#44475A',
            bg = '#6272A4',
        },
        buffer_visible = {
            fg = '#44475A',
            bg = '#6272A4',
        },
    }
})
