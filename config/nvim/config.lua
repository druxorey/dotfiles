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

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

-- CMP CONFIGURATION
local cmp = require'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    window = {
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
    }, {
        { name = 'buffer' },
    })
})

cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' }, 
    }, {
        { name = 'buffer' },
    })
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})
