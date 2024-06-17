local cmp = require 'cmp'

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn "vsnip#anonymous"
        end
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true 
        })
    },
    sources = {
        {name = 'nvim_lsp'}, 
        {name = 'vsnip'},
        {name = 'buffer'}
    }
})

cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources(
    {{name = 'git'}},
    {{name = 'buffer'}}
    )
})

cmp.setup.cmdline({'/', '?'}, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {{name = 'buffer'}}
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources(
    {{name = 'path'}},
    {{name = 'cmdline'}}
    )
})
