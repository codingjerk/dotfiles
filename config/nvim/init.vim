" === Plugins ===
source $CJ_DOTFILES/third-party/vim-plug/plug.vim
call plug#begin('$XDG_DATA_HOME/nvim/plug')

" Autocompletion
Plug 'mattn/emmet-vim'
Plug 'neoclide/coc.nvim', { 'branch': 'master', 'do': 'yarn install --frozen-lockfile' }

Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" Language support
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-python/python-syntax'

" Multiple cursors
Plug 'terryma/vim-multiple-cursors'

call plug#end()

" === Plugin settings ===
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

" python-syntax
let g:python_highlight_all = 1

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
  au VimEnter *.py set indentkeys-=<:>
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
set signcolumn=number

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

  if filename == ""
    return "<unnamed>"
  endif

  return filename
endfunction

" === Completion ===
set completeopt-=preview

" === Clipboard ===
set clipboard=unnamed,unnamedplus
let g:clipboard = {
\	'name': 'vim-clip',
\	'copy': {
\		'+': 'vim-clip save',
\		'*': 'vim-clip save',
\	},
\	'paste': {
\		'+': 'vim-clip load',
\		'*': 'vim-clip load',
\	},
\	'cache_enabled': 0,
\}

" === Misc ===
set undofile
set lazyredraw
set showmatch
set backspace=indent,eol,start
set encoding=utf8
set nowrap
set updatetime=200
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
noremap <silent> <C-T> <Esc>:tabe<CR>

inoremap <silent> <C-Q> <C-o>:tabp<CR>
inoremap <silent> <C-E> <C-o>:tabn<CR>
inoremap <silent> <C-T> <C-o>:tabe<CR>

" = Search =
nnoremap n nzz
nnoremap N Nzz

nnoremap <silent> b :noh<CR>

" = Fzf =
" by @jmoses from https://www.reddit.com/r/vim/comments/9ifsjf/vim_fzf_question_about_switching_to_already_open/
function! s:GotoOrOpen(command, ...)
  for file in a:000
    if a:command == 'e'
      exec 'e ' . file
    else
      exec "tab drop " . file
    endif
  endfor
endfunction

command! -nargs=+ GotoOrOpen call s:GotoOrOpen(<f-args>)

nnoremap <silent> <C-O> :call fzf#run({
  \ 'sink': 'GotoOrOpen tab'
  \ })<CR>

" = Marks are very annoying when ` is tmux prefix =
map ` <nop>

" = F1 is really close to escape =
nmap <F1> <Esc>
imap <F1> <Esc>

" = Indentation =
let g:pyindent_open_paren = '&sw'
let g:pyindent_nested_paren = '&sw'
let g:pyindent_continue = '&sw'

vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

nnoremap <Tab> v><Esc>
nnoremap <S-Tab> v<<Esc>

" = Emmet =
imap <expr> <C-F> emmet#expandAbbrIntelligent("\<tab>")

" = CoC =
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <c-p> coc#refresh()
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)
nnoremap <silent> <space>h :call <SID>show_documentation()<CR>
nnoremap <silent> <space>f :call CocAction('format')<CR>
nnoremap <silent> <space>i :call CocAction('runCommand', 'editor.action.organizeImport')<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" === Database integraion ===
set splitbelow

nnoremap <silent> <M-CR> :w !./run > /tmp/dbout 2>&1<CR>:split /tmp/dbout<CR>
vnoremap <silent> <M-CR> :w !./run > /tmp/dbout 2>&1<CR>:split /tmp/dbout<CR>

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
