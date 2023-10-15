" ## plugin setup

" ### pathogen
execute pathogen#infect()

" ### ctrlp.vim
set runtimepath^=~/.vim/bundle/ctrlp.vim
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_user_command = 'find %s -type f'
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(exe|so|dll)$',
    \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
    \ }

" ### molokai color scheme
let g:molokai_original = 1
let g:rehash256 = 1

" ### nerdtree
let NERDTreeWinSize = 25
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" ### taglist
let Tlist_Ctags_Cmd = 'ctags'
let Tlist_Show_One_File = 1
let Tlist_Sort_Type = "name"
let Tlist_Use_Right_Window = 1
let Tlist_Use_SingleClick = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_WinWidth = 30
let Tlist_Auto_Highlight_Tag = 1
let Tlist_Auto_Open = 0
let Tlist_Auto_Update = 1

" ### vim-airline
set laststatus=2
let g:airline_powerline_fonts = 1

" ### vim-airline-themes
let g:airline_theme='wombat'

" ### syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 0
"let g:syntastic_check_on_wq = 0


" ## generial setup
set hlsearch
set tabstop=4
" set expandtab
set shiftwidth=4
set encoding=utf-8
set t_Co=256
set background=dark
set cursorline
syntax on
colorscheme molokai
set wildmenu
set wildmode=longest:full,full
set clipboard=unnamed


" ## keymap setup
nnoremap <silent> <F4> :set expandtab<CR>
nnoremap <silent> <F5> :set invnumber<CR>
nnoremap <silent> <F6> :NERDTreeToggle<CR>
nnoremap <silent> <F7> :TlistToggle<CR>
nnoremap <silent> <F8> :wincmd p<CR>
nnoremap <silent> <F12> :!ctags -R -a --c-kinds=+l --c++-kinds=+l --fields=+iaS --extra=+q --languages=-all,+c,+c++ ./<CR><CR>


" ## open to the last position +++++
" req: sudo chown $USER:$USER ~/.viminfo
if has("autocmd")
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif


" ## for arduino
autocmd! BufNewFile,BufRead *.ino 			setlocal ft=arduino
autocmd! BufNewFile,BufRead *.pde 			setlocal ft=arduino
autocmd! BufNewFile,BufRead [Cc]onfig.in 	setlocal ft=kconfig

" ## for makefile
autocmd! BufNewFile,BufRead *.gmk			set syntax=make
