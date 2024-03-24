let g:telescope = "lua require('telescope.builtin')"

" Remap escape
nnoremap <C-c> <Esc>

" Use alt + hjkl to resize windows
nnoremap <M-j> :resize -2<CR>
nnoremap <M-k> :resize +2<CR>
nnoremap <M-h> :vertical resize -2<CR>
nnoremap <M-l> :vertical resize +2<CR>

" Alternate way to save
nnoremap <C-s> :w<CR>
" Alternate way to quit and save
nnoremap <C-q> :wq!<CR>

" Close current buffer
nnoremap <C-b> :bd<CR>

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" Move selected line / block of text in visual mode

" shift + k to move up
xnoremap K :move '<-2<CR>gv-gv
" shift + j to move down
xnoremap J :move '>+1<CR>gv-gv

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>e :NvimTreeToggl<CR>

" Telescope
nnoremap <leader>sf :execute g:telescope . '.find_files()'<CR>
nnoremap <leader>sg :execute g:telescope . '.git_files()'<CR>
nnoremap <leader>ss :execute g:telescope . ".grep_string({ search = vim.fn.input('Grep > ') })"<CR>

if !exists('g:vscode')
    " TAB in general mode will move to next buffer
    nnoremap <TAB> :bnext<CR>
    " SHIFT-TAB will go to prev buffer
    nnoremap <S-TAB> :bprevious<CR>
endif

