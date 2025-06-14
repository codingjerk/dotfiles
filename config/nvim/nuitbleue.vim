set background=dark

source $VIMRUNTIME/colors/vim.lua
let g:colors_name = "nuitbleue"

let s:bg="#1d2433"
let s:bg_dim="#1a202e"
let s:bg_dim_more="#171c29"
let s:bg_sel="#333e59"
let s:bg_sel_hi="#293145"

let s:fg="#bfd3ff"
let s:fg_half_dim="#54678c"
let s:fg_dim="#3d4a66"

let s:red="#D0879D"
let s:orange="#D0B1A2"
let s:yellow="#CDD2AF"
let s:green="#9FD6B6"
let s:blue="#92b7ea"
let s:purple="#AD9BEA"
let s:pink="#CD9BCC"

let s:accent_dim="#7C7FB7"

function! s:hl(group, fg, bg)
  exec "highlight " . a:group . " guifg=" . a:fg . " guibg=" . a:bg
endfunction

" Backgrounds
call s:hl("Normal", s:fg, s:bg)
call s:hl("CursorLine", "NONE", s:bg_dim)
call s:hl("CursorLineNr", s:blue, s:bg_dim)
call s:hl("Visual", "NONE", s:bg_sel)
call s:hl("SignColumn", "NONE", s:bg)
call s:hl("FoldColumn", "NONE", s:bg)

call s:hl("TabLine", "NONE", s:bg_dim)
call s:hl("TabLineFill", "NONE", s:bg_dim)
highlight TabLineFill gui=none

call s:hl("StatusLine", s:purple, "NONE")
highlight StatusLine gui=none

call s:hl("StatusLineNC", s:fg_dim, "NONE")
highlight StatusLineNC gui=none

call s:hl("NormalFloat", "NONE", s:bg_dim)
call s:hl("FloatBorder", s:bg_dim, s:bg_dim)

" Color column
call s:hl("NonText", s:fg_dim, "NONE")
call s:hl("WinSeparator", s:fg_dim, "NONE")
call s:hl("CursorColumn", "NONE", s:fg_dim)

" Ident guide
call s:hl("IblScope", s:accent_dim, "NONE")

" Cursor
call s:hl("MatchParen", s:purple, s:bg_sel)
call s:hl("Cursor", s:bg, s:fg_half_dim)
call s:hl("MultiCursorSign", s:blue, "NONE")
" exec "hi MatchParen gui=underline guisp=" . s:purple

" Search
call s:hl("Search",    s:yellow, "NONE")
call s:hl("CurSearch", s:yellow, "NONE")
call s:hl("IncSearch", s:yellow, "NONE")
exec "hi Search gui=underline guisp=" . s:yellow
exec "hi CurSearch gui=underline guisp=" . s:yellow
exec "hi IncSearch gui=underline guisp=" . s:yellow

" Autocomplete menu
call s:hl("Pmenu", s:fg, s:bg)
call s:hl("PmenuSel", s:fg, s:bg_sel)
call s:hl("PmenuThumb", s:fg_dim, s:fg_dim)
call s:hl("PmenuSbar", s:red, s:bg_dim)

" Dimmed text
call s:hl("LineNr", s:fg_dim, s:bg)
call s:hl("Comment", s:fg_half_dim, "NONE")
call s:hl("Question", s:fg_half_dim, "NONE")

" Trailing white space
call s:hl("EoLSpace", s:red, "NONE")
match EoLSpace /\s\+$/

" White
call s:hl("Statement", s:fg, "NONE")
call s:hl("Identifier", s:fg, "NONE")

" Blue (functions)
call s:hl("Function", s:blue, "NONE")
call s:hl("Todo", s:blue, "NONE")
call s:hl("@tag.html", s:blue, "NONE")
call s:hl("@tag.xml", s:blue, "NONE")
call s:hl("@tag.vue", s:blue, "NONE")
call s:hl("@tag.delimiter.vue", s:blue, "NONE")
call s:hl("@tag.delimiter", s:blue, "NONE")
call s:hl("dosiniLabel", s:blue, "NONE")
call s:hl("tomlKey", s:blue, "NONE")

" Red (mutable variables)
call s:hl("@lsp.mod.mutable", s:red, "NONE")

" Purple (keywords, directories, html attributes)
call s:hl("Keyword", s:purple, "NONE")
call s:hl("@keyword", s:purple, "NONE")
call s:hl("@keyword.repeat", s:purple, "NONE")
call s:hl("@keyword.import", s:purple, "NONE")
call s:hl("@keyword.exception", s:purple, "NONE")
call s:hl("@keyword.conditional", s:purple, "NONE")
call s:hl("@keyword.type.python", s:purple, "NONE")
call s:hl("Directory", s:purple, "NONE")
call s:hl("@tag.attribute.html", s:purple, "NONE")
call s:hl("@tag.attribute.xml", s:purple, "NONE")
call s:hl("@tag.attribute.vue", s:purple, "NONE")
call s:hl("dosiniHeader", s:purple, "NONE")
call s:hl("zigVarDecl", s:purple, "NONE")
call s:hl("zigConditional", s:purple, "NONE")
call s:hl("zigExecution", s:purple, "NONE")

call s:hl("CfgSection", s:purple, "NONE")
call s:hl("tomlTable", s:purple, "NONE")
call s:hl("tomlTableArray", s:purple, "NONE")
call s:hl("Title", s:purple, "NONE")

" Green (strings)
call s:hl("String", s:green, "NONE")
call s:hl("CfgValues", s:green, "NONE")
call s:hl("CfgOnOff", s:green, "NONE")
call s:hl("@punctuation.special.vue", s:green, "NONE")

" Yellow (constants)
call s:hl("Constant", s:yellow, "NONE")
call s:hl("@constant.bash", s:blue, "NONE") " special case

" Orange (types, classes)
call s:hl("Type", s:orange, "NONE")
call s:hl("@constructor", s:orange, "NONE")
call s:hl("@type.builtin", s:orange, "NONE")
call s:hl("@character.rust", s:orange, "NONE") " special case to distinguish from strings
call s:hl("@character.zig", s:orange, "NONE")

" Pink (special, rare, important, builtins)
call s:hl("Special", s:pink, "NONE")
call s:hl("PreProc", s:pink, "NONE")
call s:hl("@boolean", s:pink, "NONE")
call s:hl("@constant.html", s:pink, "NONE")
call s:hl("@lsp.type.builtin.zig", s:pink, "NONE")
call s:hl("zigBuiltinFn", s:pink, "NONE")
call s:hl("zigNull", s:pink, "NONE")
call s:hl("@keyword.import.zig", s:pink, "NONE")

" Disabled
call s:hl("Delimiter", s:fg_half_dim, "NONE")
call s:hl("Operator", s:fg_half_dim, "NONE")
call s:hl("@constructor.lua", s:fg_half_dim, "NONE")
call s:hl("@tag.delimiter.html", s:fg_half_dim, "NONE")
call s:hl("dosiniSection", s:fg_half_dim, "NONE")
call s:hl("Conceal", s:red, s:green)

" Diagnostic
call s:hl("DiagnosticError", s:red, "NONE")
call s:hl("Error", s:red, "NONE")
call s:hl("ErrorMsg", s:red, "NONE")
call s:hl("DiagnosticOk", s:green, "NONE")

call s:hl("DiagnosticWarn", s:orange, "NONE")
call s:hl("WarningMsg", s:orange, "NONE")
exec "highlight SpellBad" . " guisp=" . s:orange

call s:hl("DiagnosticInfo", s:fg_half_dim, "NONE")
call s:hl("DiagnosticHint", s:fg_half_dim, "NONE")

exec "highlight DiagnosticUnderlineHint gui=NONE"
exec "highlight DiagnosticUnderlineInfo gui=NONE"
exec "highlight DiagnosticUnderlineWarn gui=NONE"
exec "highlight DiagnosticUnderlineError gui=NONE"

" Notifications
call s:hl("NotifyBackground", s:bg_dim, s:bg_dim)
call s:hl("NotifyERRORBody", s:red, s:bg_dim)
call s:hl("NotifyERRORBorder", s:bg_dim, s:bg_dim)
call s:hl("NotifyERRORIcon", s:red, "NONE")
call s:hl("NotifyERRORTitle", s:red, "NONE")

call s:hl("NotifyWARNBody", s:bg_dim, s:bg_dim)
call s:hl("NotifyWARNBorder", s:bg_dim, s:bg_dim)
call s:hl("NotifyWARNIcon", s:orange, "NONE")
call s:hl("NotifyWARNTitle", s:orange, "NONE")

call s:hl("NotifyINFOBody", s:bg_dim, s:bg_dim)
call s:hl("NotifyINFOBorder", s:bg_dim, s:bg_dim)
call s:hl("NotifyINFOIcon", s:blue, "NONE")
call s:hl("NotifyINFOTitle", s:blue, "NONE")

call s:hl("NotifyDEBUGBody", s:bg_dim, s:bg_dim)
call s:hl("NotifyDEBUGBorder", s:bg_dim, s:bg_dim)
call s:hl("NotifyDEBUGIcon", s:fg_dim, "NONE")
call s:hl("NotifyDEBUGTitle", s:fg_dim, "NONE")

call s:hl("NotifyTRACEBody", s:bg_dim, s:bg_dim)
call s:hl("NotifyTRACEBorder", s:bg_dim, s:bg_dim)
call s:hl("NotifyTRACEIcon", s:fg_dim, "NONE")
call s:hl("NotifyTRACETitle", s:fg_dim, "NONE")

" Diff
call s:hl("DiffAdd", s:green, "NONE")
call s:hl("GitSignsAdd", s:green, "NONE")
call s:hl("GitSignsStagedAdd", s:green, "NONE")
call s:hl("GitSignsStagedAddNr", s:green, "NONE")

call s:hl("DiffChange", s:purple, "NONE")
call s:hl("Changed", s:purple, "NONE")
call s:hl("GitSignsChange", s:purple, "NONE")
call s:hl("GitSignsStagedChange", s:purple, "NONE")
call s:hl("GitSignsStagedChangeNr", s:purple, "NONE")

call s:hl("DiffDelete", s:red, "NONE")
call s:hl("Removed", s:red, "NONE")
call s:hl("GitSignsDelete", s:red, "NONE")
call s:hl("GitSignsStagedDelete", s:red, "NONE")
call s:hl("GitSignsStagedDeleteNr", s:red, "NONE")

" Language:Markdown
call s:hl("@markup.list.markdown", s:fg_dim, "NONE")
call s:hl("@markup.list.checked.markdown", s:fg_dim, "NONE")
call s:hl("@markup.list.unchecked.markdown", s:red, "NONE")
call s:hl("@markup.raw.markdown_inline", s:green, "NONE")
call s:hl("@markup.raw.block.markdown", s:fg_half_dim, "NONE")
call s:hl("@label.markdown", s:orange, "NONE")
call s:hl("@markup.quote.markdown", s:fg, "NONE")
hi @markup.quote.markdown gui=italic
call s:hl("@punctuation.special.markdown", s:fg_half_dim, "NONE")
call s:hl("@markup.link.url.markdown_inline", s:fg_half_dim, "NONE")
call s:hl("@markup.link.label.markdown_inline", s:blue, "NONE")
hi @markup.link.url.markdown_inline gui=underline

" Language:calendar
call s:hl("calendarMonth", s:purple, "NONE")

" Plugin:Telescope
call s:hl("TelescopeNormal", s:fg, s:bg_dim)
call s:hl("TelescopeBorder", s:bg_dim, s:bg_dim)

call s:hl("TelescopePromptNormal", s:fg, s:bg_dim_more)
call s:hl("TelescopePromptTitle", s:fg, s:bg_dim_more)
call s:hl("TelescopePromptBorder", s:bg_dim_more, s:bg_dim_more)

call s:hl("TelescopePreviewBorder", s:bg_dim, s:bg_dim)
call s:hl("TelescopePreviewTitle", s:bg_dim, s:bg_dim)

call s:hl("TelescopeSelectionCaret", s:bg_sel, s:bg_sel)

" Plugin:Noice
call s:hl("NoiceCmdlinePopup", s:fg, s:bg_dim)
call s:hl("NoiceCmdlinePopupBorder", s:bg_dim, s:bg_dim)
call s:hl("NoicePopup", "NONE", s:bg_dim)

" Plugin:Diagflow
call s:hl("DiagnosticFloatingError", s:red, s:bg_dim)
call s:hl("DiagnosticFloatingWarn", s:orange, s:bg_dim)
call s:hl("DiagnosticFloatingOK", s:fg_half_dim, s:bg_dim)
call s:hl("DiagnosticFloatingInfo", s:fg_half_dim, s:bg_dim)
call s:hl("DiagnosticFloatingHint", s:fg_half_dim, s:bg_dim)

" Plugin:LocalHighlight
call s:hl("LocalHighlight", "NONE", s:bg_sel_hi)

" Plugin:Oil
call s:hl("OilFile", s:blue, "NONE")
