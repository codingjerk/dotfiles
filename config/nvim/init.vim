" === Plugins ===
source $CJ_DOTFILES/third-party/vim-plug/plug.vim
call plug#begin('$XDG_DATA_HOME/nvim/plug')

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1

Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
set hidden
set completeopt-=preview
set signcolumn=no
let g:LanguageClient_serverCommands = {
  \ 'rust': ['rls'],
  \ 'python': ['pyls'],
  \ 'javascript': ['javascript-typescript-stdio'],
  \ 'typescript': ['javascript-typescript-stdio'],
  \ }
let g:LanguageClient_diagnosticsEnable = 0
autocmd CompleteDone * silent! pclose!

Plug 'w0rp/ale'
let g:ale_completion_enabled = 0
let g:ale_linters_explicit = 1
let g:ale_linters = {
  \ 'bash': ['shellcheck'],
  \ 'sh': ['shellcheck'],
  \ 'javascript': ['eslint'],
  \ 'markdown': ['write-good'],
  \ 'rust': ['cargo'],
  \ }
let g:ale_fixers = {
  \ 'bash': ['shfmt'],
  \ 'sh': ['shfmt'],
  \ 'html': ['prettier'],
  \ 'javascript': ['prettier'],
  \ 'rust': ['rustfmt'],
  \ }

Plug 'editorconfig/editorconfig-vim'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

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

" === Diff ===
set diffopt=filler,context:4,foldcolumn:0

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

" === Statusline ===
set noshowmode
set shortmess+=c

set laststatus=2
set statusline=
set statusline+=%4*%{(mode()=='n')?(&mod==0)?'\ \ NORMAL\ ':'':''}
set statusline+=%5*%{(mode()=='n')?(&mod==1)?'\ \ NORMAL\ ':'':''}
set statusline+=%4*%{(mode()=='c')?(&mod==0)?'\ \ NORMAL\ ':'':''}
set statusline+=%5*%{(mode()=='c')?(&mod==1)?'\ \ NORMAL\ ':'':''}
set statusline+=%5*%{(mode()=='i')?'\ \ INSERT\ ':''}
set statusline+=%6*%{(mode()=='v')?'\ \ VISUAL\ ':''}
set statusline+=%1*%{(&ro==1)?'\ \ RO\ ':''}
set statusline+=%9*\ %f\ "

set statusline+=%9*%=
set statusline+=%l/%L\ " Line number
set statusline+=%4*\ %Y\ "
set statusline+=%6*\ %{&fenc}\ "

" === Misc ===
set lazyredraw
set showmatch
set backspace=indent,eol,start
set encoding=utf8
set nowrap
let g:netrw_home=$XDG_CACHE_HOME.'/nvim'

" === Keybindings ===
" = Colon =
nnoremap ; :

" = WASD =
noremap w k
noremap s j
noremap a h
noremap d l

noremap A b
noremap D w
vnoremap D e

noremap W 5k
noremap S 5j

noremap x d

" = Q/E for insertion =
nnoremap q I
nnoremap e A
vnoremap <expr> q mode()=~'\cv' ? "<C-V>^I" : "I"
vnoremap <expr> e mode()=~'\cv' ? "<C-V>$A" : "$A"

" = Tabs =
noremap <silent> <C-Q> <Esc>:tabp<CR>
noremap <silent> <C-E> <Esc>:tabn<CR>

inoremap <silent> <C-Q> <C-o>:tabp<CR>
inoremap <silent> <C-E> <C-o>:tabn<CR>

" = Fzf =
if filereadable('/usr/share/vim/vimfiles/plugin/fzf.vim')
  source /usr/share/vim/vimfiles/plugin/fzf.vim
elseif glob('$VIMRUNTIME/plugin/fzf.vim')!=#""
  source $VIMRUNTIME/plugin/fzf.vim
endif

nnoremap <silent> <C-O> :call fzf#run({'sink': 'tabedit'})<CR>

" = Marks are very annoying when ` is tmux prefix =
map ` <nop>

" = Indentation =
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

nnoremap <Tab> v><Esc>
nnoremap <S-Tab> v<<Esc>

" = Completion =
imap <expr><Tab> pumvisible()
  \ ? "\<C-n>"
  \ : neosnippet#expandable_or_jumpable()
  \ ? "\<Plug>(neosnippet_expand_or_jump)"
  \ : "\<Tab>"

smap <expr><Tab> neosnippet#expandable_or_jumpable()
  \ ? "\<Plug>(neosnippet_expand_or_jump)"
  \ : "\<Tab>"

imap <expr><S-Tab> pumvisible()
  \ ? "\<C-p>"
  \ : "\<C-o>:<<CR>"

imap <expr><CR> neosnippet#expandable_or_jumpable()
  \ ? "\<Plug>(neosnippet_expand_or_jump)"
  \ : "\<CR>"

" === Linting ===
nnoremap <silent> <C-f> :ALEFix<CR>
nnoremap <silent> <C-s> :set spell!<CR>

" === Highlighting ===
set t_Co=16
colorscheme cj
syntax enable
au BufReadPost *.in set syntax=sh

hi User1 ctermbg=0 ctermfg=1 cterm=reverse
hi User2 ctermbg=0 ctermfg=2 cterm=reverse
hi User3 ctermbg=0 ctermfg=3 cterm=reverse
hi User4 ctermbg=0 ctermfg=4 cterm=reverse
hi User5 ctermbg=0 ctermfg=5 cterm=reverse
hi User6 ctermbg=0 ctermfg=6 cterm=reverse
hi User9 none

" = Misc =
map <F1> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
