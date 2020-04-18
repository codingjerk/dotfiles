" === Plugins ===
source $CJ_DOTFILES/third-party/vim-plug/plug.vim
call plug#begin('$XDG_DATA_HOME/nvim/plug')

" Autocompletion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'mattn/emmet-vim'

Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" Language support
Plug 'leafgarland/typescript-vim'
Plug 'editorconfig/editorconfig-vim'

" Multiple cursors
Plug 'terryma/vim-multiple-cursors'

" Time tracking
Plug 'wakatime/vim-wakatime'

call plug#end()

" === Plugin settings ===
" deoplete
let g:deoplete#enable_at_startup = 1
let g:omni_sql_no_default_maps = 1

" vim-multiple-cursors
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_start_word_key      = '<C-d>'
let g:multi_cursor_next_key            = '<C-d>'

let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

" === Timeouts ===
set ttimeoutlen=10
set timeoutlen=200

" === Whitespace ===
augroup whitespace
  au VimEnter * set tabstop=2
  au VimEnter * set softtabstop=2
  au VimEnter * set shiftwidth=2
  au VimEnter * set expandtab
augroup END

augroup whitespace_python
  au VimEnter *.py set tabstop=4
  au VimEnter *.py set softtabstop=4
  au VimEnter *.py set shiftwidth=4
  au VimEnter *.py set expandtab
augroup END

augroup whitespace_rust
  au VimEnter *.rs set tabstop=4
  au VimEnter *.rs set softtabstop=4
  au VimEnter *.rs set shiftwidth=4
  au VimEnter *.rs set expandtab
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
set nowrapscan

" === Indentation ===
set autoindent
set smartindent
set smarttab
set indentkeys-=<:>

" === Backup ===
set nobackup
set nowritebackup
set noswapfile

" === Statusline ===
set noshowmode
set shortmess+=catI

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
set statusline+=%4*%{(&filetype=='')?'':'\ '.&filetype.'\ '}"
set statusline+=%6*%{(&fenc=='')?'':'\ \ '.&fenc.'\ '}"

" === Tabline ===
set tabline=%!MyTabLine()

function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor

  return s
endfunction

function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let path = bufname(buflist[winnr - 1])
  let filename = fnamemodify(path, ":t")

  return filename
endfunction

" === Completion ===
set completeopt-=preview

" === Misc ===
set clipboard=unnamed,unnamedplus
set undofile
set lazyredraw
set showmatch
set backspace=indent,eol,start
set encoding=utf8
set nowrap
set cursorline
let g:netrw_home=$XDG_CACHE_HOME.'/nvim'

autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

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

" = {c,x}Q/E for change / delete =
noremap xe d$
noremap xq d^
noremap ce c$
noremap cq c^

" = Tabs =
noremap <silent> <C-Q> <Esc>:tabp<CR>
noremap <silent> <C-E> <Esc>:tabn<CR>

inoremap <silent> <C-Q> <C-o>:tabp<CR>
inoremap <silent> <C-E> <C-o>:tabn<CR>

" = Search =
nnoremap n nzz
nnoremap N Nzz

nnoremap <silent> b :noh<CR>

" = Fzf =
nnoremap <silent> <C-O> :call fzf#run({
  \ 'sink': 'tabe'
  \ })<CR>

" = Marks are very annoying when ` is tmux prefix =
map ` <nop>

" = F1 is really close to escape =
nmap <F1> <Esc>
imap <F1> <Esc>

" = Indentation =
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

nnoremap <Tab> v><Esc>
nnoremap <S-Tab> v<<Esc>

" = Completion =
imap <expr><Tab> pumvisible()
  \ ? "\<C-n>"
  \ : "\<Tab>"

imap <expr><S-Tab> pumvisible()
  \ ? "\<C-p>"
  \ : "\<C-o>:<<CR>"

" = Emmet =
imap <expr> <C-F> emmet#expandAbbrIntelligent("\<tab>")

" === Highlighting ===
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

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
