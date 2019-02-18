set background=dark
hi clear Normal
hi clear
syntax reset

" = UI =
hi ErrorMsg ctermbg=1 ctermfg=0
hi WarningMsg ctermbg=5 ctermfg=0
hi Visual ctermbg=7 ctermfg=0 cterm=reverse,bold
hi Search ctermbg=0 ctermfg=3 cterm=reverse

hi ALEErrorLine ctermbg=0 ctermfg=5 cterm=reverse

hi VertSplit ctermbg=0 ctermfg=0 cterm=bold
hi LineNr ctermfg=0 cterm=bold
hi MatchParen ctermfg=0 ctermbg=0 cterm=reverse,bold
hi TabLine ctermfg=0 ctermbg=0 cterm=bold
hi TabLineFill ctermfg=0 ctermbg=0 cterm=bold

hi EndOfBuffer ctermfg=0
hi SignColumn ctermbg=0

hi Pmenu ctermbg=0 ctermfg=0 cterm=bold
hi PmenuSel ctermfg=7
hi PmenuSbar ctermfg=0 cterm=bold,reverse
hi PmenuThumb ctermbg=7

" = Diff =
hi Folded ctermbg=0 ctermfg=0 cterm=bold

hi DiffAdd    ctermbg=0 ctermfg=2 cterm=reverse
hi DiffDelete ctermbg=0 ctermfg=1 cterm=reverse
hi DiffChange ctermbg=0 ctermfg=3 cterm=reverse
hi DiffText   ctermbg=0 ctermfg=5 cterm=reverse

hi diffAdded   ctermfg=2
hi diffChanged ctermfg=3
hi diffFile    ctermfg=6

" = General =
hi Comment ctermfg=0 cterm=bold
hi Whitespace ctermfg=1 cterm=none

hi Title ctermfg=1
hi Special ctermfg=1
hi Todo ctermfg=0 ctermbg=1

hi Type ctermfg=3

hi PreProc ctermfg=4
hi Underlined ctermfg=4

hi Constant ctermfg=5

hi Statement ctermfg=6

" = Vim =
hi vimString ctermfg=2

" = Shell =
hi shSingleQuote ctermfg=2
hi shDoubleQuote ctermfg=2

hi zshString ctermfg=2

" = Toml =
hi tomlTable ctermfg=1
hi tomlString ctermfg=2

" = Rust =
hi rustKeyword ctermfg=1
hi rustMacro ctermfg=1
hi rustString ctermfg=2

" = Speling =
hi SpellBad  ctermbg=0 ctermfg=1 cterm=reverse
hi SpellCap  ctermbg=0 ctermfg=1 cterm=reverse
hi SpellRare ctermbg=0 ctermfg=5 cterm=reverse
