set termguicolors

function! s:Colors()
  highlight Normal cterm=NONE ctermbg=233 gui=NONE guibg=NONE
  highlight CursorLine cterm=NONE ctermbg=234 gui=NONE guibg=NONE
endfunction

augroup darken_bg | autocmd!
    autocmd! Colorscheme * call s:Colors()
augroup END

set cursorline

colorscheme dracula
let g:airline_theme = 'dracula'
