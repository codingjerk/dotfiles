set background=dark
hi clear Normal
hi clear
syntax reset

" = UI =
hi ErrorMsg ctermbg=none ctermfg=1 cterm=none
hi Error ctermbg=none ctermfg=1 cterm=none
hi WarningMsg ctermbg=3 ctermfg=0
hi healthSuccess ctermbg=2 ctermfg=0
hi Visual ctermbg=0 ctermfg=7 cterm=reverse
hi MoreMsg ctermfg=2

" CoC
hi CocFloating ctermbg=0 ctermfg=0 cterm=bold
hi CocWarningFloat ctermfg=3
hi CocWarningSign ctermfg=3

" NOTE: ctermfg=16 is not an error, ctermfg=0 behaves strange sometimes
hi Search ctermfg=16 ctermbg=3 cterm=none

hi ALEErrorLine ctermbg=0 ctermfg=5 cterm=reverse

hi VertSplit ctermbg=0 ctermfg=0 cterm=bold
hi LineNr ctermfg=0 cterm=bold
hi MatchParen ctermfg=0 ctermbg=6 cterm=none
hi TabLine ctermfg=0 ctermbg=0 cterm=bold
hi TabLineFill ctermfg=0 ctermbg=0 cterm=bold

hi EndOfBuffer ctermfg=0
hi SignColumn ctermbg=0

hi Pmenu ctermbg=none ctermfg=7 cterm=bold
hi PmenuSel ctermbg=none ctermfg=7 cterm=none
hi PmenuSbar ctermbg=none ctermfg=0 cterm=none
hi PmenuThumb ctermbg=none

hi CursorColumn ctermbg=235 ctermfg=none cterm=none
hi CursorLine ctermbg=235 ctermfg=none cterm=none
hi CursorLineNR ctermfg=4 ctermbg=235 cterm=none

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
hi Underlined ctermfg=6

hi Constant ctermfg=5

hi Statement ctermfg=4
hi Identifier ctermfg=4
hi String ctermfg=2

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

" = XML =
hi xmlAttrib ctermfg=6
hi xmlNamespace ctermfg=6

" = Speling =
hi SpellBad  ctermbg=0 ctermfg=1 cterm=reverse
hi SpellCap  ctermbg=0 ctermfg=1 cterm=reverse
hi SpellRare ctermbg=0 ctermfg=5 cterm=reverse
