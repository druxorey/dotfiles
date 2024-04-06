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

" < or > to tab
vnoremap < <gv
vnoremap > >gv

" shift + k/j to move selected line up/down
xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv

" Use Ctrl + hjkl to move between windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>e :NvimTreeToggl<CR>

" Telescope
nnoremap <leader>sf :execute g:telescope . '.find_files()'<CR>
nnoremap <leader>sg :execute g:telescope . '.git_files()'<CR>
nnoremap <leader>ss :Telescope current_buffer_fuzzy_find<CR>

" TAB in general mode will move to next buffer
if !exists('g:vscode')
    nnoremap <TAB> :bnext<CR>
    nnoremap <S-TAB> :bprevious<CR>
endif

