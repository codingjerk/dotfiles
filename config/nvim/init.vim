" === Plugins ===
call plug#begin('$XDG_DATA_HOME/nvim/plug')

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1

" Tab cycle completion
inoremap <expr><Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <C-Space> <C-n>

Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
set hidden
set splitbelow
set splitright
set signcolumn=no
let g:LanguageClient_serverCommands = {
  \ 'rust': ['$CARGO_HOME/bin/rls'],
  \ 'python': ['pyls'],
  \ 'javascript': ['javascript-typescript-stdio'],
  \ 'typescript': ['javascript-typescript-stdio'],
  \ }
let g:LanguageClient_diagnosticsEnable = 1
autocmd CompleteDone * silent! pclose!

call plug#end()

" === Timeouts ===
set ttimeoutlen=10
set timeoutlen=200

" === Whitespace ===
augroup whitespace
  au VimEnter *.* set tabstop=2
  au VimEnter *.* set softtabstop=2
  au VimEnter *.* set shiftwidth=2
  au VimEnter *.* set expandtab
augroup END

set list " show whitespace
set listchars=tab:»-,trail:•,nbsp:_

" === Gutter ===
set number
set numberwidth=1

" === Search ===
set hlsearch
set incsearch
set smartcase
set ignorecase

" === Indentation ===
set autoindent
set smartindent
set smarttab

" === Backup ===
set nobackup
set nowritebackup
set noswapfile

" === Misc ===
set lazyredraw
set showmatch
set backspace=indent,eol,start
set laststatus=0
set encoding=utf8
set nowrap
let g:netrw_home=$XDG_CACHE_HOME.'/nvim'

" === Keybindings ===
" = Colon =
nnoremap ; :

" = WASD =
nnoremap w k
nnoremap s j
nnoremap a h
nnoremap d l

vnoremap w k
vnoremap s j
vnoremap a h
vnoremap d l

nnoremap A b
nnoremap D w
vnoremap A b
vnoremap D w

nnoremap W 5k
nnoremap S 5j
vnoremap W 5k
vnoremap S 5j

noremap xx dd
vnoremap x d

" = Q/E for insertion =
nnoremap q I
nnoremap e A
vnoremap q I
vnoremap e A

nnoremap Q O
nnoremap E o

" = Tabs =
nnoremap <silent> <C-Q> <Esc>:tabp<CR>
inoremap <silent> <C-Q> <C-o>:tabp<CR>
vnoremap <silent> <C-Q> <Esc>:tabp<CR>
nnoremap <silent> <C-E> <Esc>:tabn<CR>
inoremap <silent> <C-E> <C-o>:tabn<CR>
vnoremap <silent> <C-E> <Esc>:tabn<CR>

" = Fzf =
if filereadable("/usr/share/vim/vimfiles/plugin/fzf.vim")
  source /usr/share/vim/vimfiles/plugin/fzf.vim
  nnoremap <C-O> :call fzf#run({'sink': 'tabedit'})<CR>
endif

" = Marks are very annoying when ` is tmux prefix =
map ` <nop>

" = Indentation =
vnoremap < <gv
vnoremap > >gv
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" === Highlighting ===
set t_Co=16
colorscheme cj
syntax enable
au BufReadPost *.in set syntax=sh

" = Misc =
map <F1> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
