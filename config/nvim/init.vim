" === Timeouts ===
set ttimeoutlen=10
set timeoutlen=200

" === Whitespace ===
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" === Gutter ===
set number
set numberwidth=1
set nowrap

" === Search ===
set hlsearch
set incsearch
set smartcase
set ignorecase

" === Identation ===
set autoindent
set smartindent
set smarttab

" === Misc ===
set lazyredraw
set showmatch
set backspace=indent,eol,start
set laststatus=0

" === Keybindings ===
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

" = Ctrl+D for word selection =
inoremap <C-D> <Esc>viw
nnoremap <C-D> viw
vnoremap <C-D> iw

" = Q/E for insertion =
nnoremap q I
nnoremap e A
vnoremap q I
vnoremap e A

nnoremap Q O
nnoremap E o

" = Tabs =
nnoremap <C-Q> :tabp<CR>
inoremap <C-Q> :tabp<CR>
vnoremap <C-Q> :tabp<CR>
nnoremap <C-E> :tabn<CR>
inoremap <C-E> :tabn<CR>
vnoremap <C-E> :tabn<CR>

if filereadable("/usr/share/vim/vimfiles/plugin/fzf.vim")
  source /usr/share/vim/vimfiles/plugin/fzf.vim
  nnoremap <C-O> :call fzf#run({'sink': 'tabedit'})<CR>
endif

" = Unmapping arrows =
nmap <left> <nop>
nmap <right> <nop>
nmap <up> <nop>
nmap <down> <nop>
vmap <left> <nop>
vmap <right> <nop>
vmap <up> <nop>
vmap <down> <nop>
imap <left> <nop>
imap <right> <nop>
imap <up> <nop>
imap <down> <nop>

" === Highlighting ===
set background=dark
hi clear Normal
hi clear
syntax reset

" = UI =
hi LineNr ctermfg=0 cterm=bold
hi TabLine ctermfg=0 ctermbg=0 cterm=bold
hi TabLineFill ctermfg=0 ctermbg=0 cterm=bold

" = General =
augroup highlighting
  au VimEnter *.* hi Comment ctermfg=0 cterm=bold

  au VimEnter *.* hi Title ctermfg=1
  au VimEnter *.* hi Todo ctermfg=0 ctermbg=1

  au VimEnter *.* hi Type ctermfg=3

  au VimEnter *.* hi PreProc ctermfg=4
  au VimEnter *.* hi Underlined ctermfg=4

  au VimEnter *.* hi Constant ctermfg=5

  au VimEnter *.* hi Statement ctermfg=6

  " = Vim =
  au VimEnter *.* hi vimString ctermfg=2

  " = Shell =
  au VimEnter *.* hi shSingleQuote ctermfg=2
  au VimEnter *.* hi shDoubleQuote ctermfg=2
  au VimEnter *.* hi zshString ctermfg=2
augroup END

" = Misc =
map <F1> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
