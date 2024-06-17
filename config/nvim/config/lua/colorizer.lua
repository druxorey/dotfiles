require'colorizer'.setup()

require'colorizer'.setup {
    'css',
    'javascript',
    html = {mode = 'foreground'}
}

require'colorizer'.setup(
    {
    'css',
    'javascript',
    html = {mode = 'background'}},
    {mode = 'foreground'}
)

require'colorizer'.setup {
    '*',
    css = {rgb_fn = true},
    html = {names = false}
}

require'colorizer'.setup {'*','!vim'}
