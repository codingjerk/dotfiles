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
Plug 'cespare/vim-toml', { 'branch': 'main' }
Plug 'raimon49/requirements.txt.vim'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'lifepillar/pgsql.vim'
Plug 'LnL7/vim-nix'
Plug 'glench/vim-jinja2-syntax'
Plug 'lepture/vim-jinja'

" Multiple cursors
Plug 'terryma/vim-multiple-cursors'

call plug#end()

" === Plugin settings ===
" CoC
let g:coc_global_extensions = [
      \'coc-browser',
      \'coc-calc',
      \'coc-css',
      \'coc-html',
      \'coc-json',
      \'coc-pyright',
      \'coc-rust-analyzer',
      \'coc-sh',
      \'coc-toml',
      \'coc-vimlsp'
      \]

" vim-multiple-cursors
let g:multi_cursor_use_default_mapping = 0
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

" pgplsql
let g:sql_type_default = 'pgsql'

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

set laststatus=0
set noruler

function! s:empty_message(timer)
  if mode() ==# 'n'
    echon ''
  endif
endfunction

augroup cmd_msg_cls
    autocmd!
    autocmd CmdlineLeave :  call timer_start(2000, funcref('s:empty_message'))
augroup END

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
set linebreak
set updatetime=200
set scrolloff=2
set sidescrolloff=5
let g:netrw_home=$XDG_CACHE_HOME.'/nvim'

autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" === Keybindings ===
" = Colon =
nnoremap ; :

" = WASD =
noremap w gk
noremap s gj
noremap a h
noremap d l

noremap A b
noremap D w
vnoremap D e

noremap W 5gk
noremap S 5gj

noremap x d

" = Arrows =
noremap <UP> gk
noremap <DOWN> gj

" = Ctrl-A =
noremap <C-a> ggVG

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

" = Snippets =

nnoremap <silent> T "=strftime('%Y-%m-%d %H:%M')<CR>pa <Esc>a
vnoremap <silent> tf :w! /tmp/vim-selection<CR>:!trans :fr --no-ansi -i /tmp/vim-selection -o /tmp/vim-translation<CR>:split /tmp/vim-translation<CR>
vnoremap <silent> te :w! /tmp/vim-selection<CR>:!trans :en --no-ansi -i /tmp/vim-selection -o /tmp/vim-translation<CR>:split /tmp/vim-translation<CR>
vnoremap <silent> tr :w! /tmp/vim-selection<CR>:!trans :ru --no-ansi -i /tmp/vim-selection -o /tmp/vim-translation<CR>:split /tmp/vim-translation<CR>
vnoremap <silent> td :w! /tmp/vim-selection<CR>:!trans :de --no-ansi -i /tmp/vim-selection -o /tmp/vim-translation<CR>:split /tmp/vim-translation<CR>

" === Russian reybindings ===
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

" = Colon =
nnoremap ж :

" = WASD =
noremap ц gk
noremap ы gj
noremap ф h
noremap в l

noremap Ф b
noremap В w
vnoremap В e

noremap Ц 5gk
noremap Ы 5gj

noremap ч d

" = Q/E for insertion =
nnoremap й I
nnoremap у A
vnoremap <expr> й mode()=~'\cv' ? "<C-V>^I" : "I"
vnoremap <expr> у mode()=~'\cv' ? "<C-V>$A" : "$A"

" = {c,x}Q/E for change / delete =
noremap чу d$
noremap чй d^
noremap су c$
noremap сй c^

" = Tabs =
noremap <silent> <C-й> <Esc>:tabp<CR>
noremap <silent> <C-у> <Esc>:tabn<CR>
noremap <silent> <C-е> <Esc>:tabe<CR>

inoremap <silent> <C-й> <C-o>:tabp<CR>
inoremap <silent> <C-у> <C-o>:tabn<CR>
inoremap <silent> <C-е> <C-o>:tabe<CR>

" = Search =
nnoremap т nzz
nnoremap Т Nzz

nnoremap <silent> и :noh<CR>

" = Fzf =
nnoremap <silent> <C-щ> :call fzf#run({
  \ 'sink': 'GotoOrOpen tab'
  \ })<CR>

" = Emmet =
imap <expr> <C-а> emmet#expandAbbrIntelligent("\<tab>")

" = CoC =
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <c-з> coc#refresh()
nnoremap <silent> пd <Plug>(coc-definition)
nnoremap <silent> пш <Plug>(coc-implementation)
nnoremap <silent> пк <Plug>(coc-references)
nnoremap <silent> <space>р :call <SID>show_documentation()<CR>
nnoremap <silent> <space>а :call CocAction('format')<CR>
nnoremap <silent> <space>ш :call CocAction('runCommand', 'editor.action.organizeImport')<CR>

" = Snippets =

nnoremap <silent> Е "=strftime('%Y-%m-%d %H:%M')<CR>pa <Esc>a
vnoremap <silent> еа :w! /tmp/vim-selection<CR>:!trans :fr --no-ansi -i /tmp/vim-selection -o /tmp/vim-translation<CR>:split /tmp/vim-translation<CR>
vnoremap <silent> еу :w! /tmp/vim-selection<CR>:!trans :en --no-ansi -i /tmp/vim-selection -o /tmp/vim-translation<CR>:split /tmp/vim-translation<CR>
vnoremap <silent> ек :w! /tmp/vim-selection<CR>:!trans :ru --no-ansi -i /tmp/vim-selection -o /tmp/vim-translation<CR>:split /tmp/vim-translation<CR>
vnoremap <silent> ев :w! /tmp/vim-selection<CR>:!trans :de --no-ansi -i /tmp/vim-selection -o /tmp/vim-translation<CR>:split /tmp/vim-translation<CR>

" === Minimalistic build system ===
set splitbelow

nnoremap <silent> <M-CR> :w !make > /tmp/vimrunout 2>&1<CR>:split /tmp/vimrunout<CR>
vnoremap <silent> <M-CR> :w !make > /tmp/vimrunout 2>&1<CR>:split /tmp/vimrunout<CR>

" === Spelling ===
set spelllang=en_us,ru

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
