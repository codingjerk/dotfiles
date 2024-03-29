# === Tools ===
export EDITOR='helix'
export VISUAL="${EDITOR}"
export PAGER='less'

# === GUI Tools ===
export TERMINAL='footclient'
export BROWSER='open'

# === Options ===
export FZF_DEFAULT_COMMAND='fd -t f -t l -S-10M -H --color=always -E .git/'
export FZF_DEFAULT_OPTS="--exact --ansi --color='hl:6,fg+:1,bg+:0,hl+:6,info:2,prompt:2,pointer:1,marker:5' --layout=reverse --inline-info --no-mouse"

export GREP_COLORS='sl=0:cx=1;30:fn=0;33:ln=0;35'

export LESS='-imRSc -x4 -z-4 -#10 -j8'

export PASSWORD_STORE_CLIP_TIME=8

export HOMEBREW_NO_AUTO_UPDATE=1

export MOZ_ENABLE_WAYLAND=1

# === LS_COLORS ===
LS_COLORS='no=0:fi=0:di=34'

LS_COLORS+=':*.c=31:*.rs=31:*.lock=31'
LS_COLORS+=':ex=32:ln=32:*.exe=32:*.cmd=32:*.com=32'

LS_COLORS+=':*.mp3=33:*.wav=33'
LS_COLORS+=':*.png=33:*.jpg=33:*.jpeg=33:*.svg=33'
LS_COLORS+=':*.mp4=33:*.mkv=33'
LS_COLORS+=':*.pdf=33:*.djvu=33'

LS_COLORS+=':*.md=35:*.tex=35:*.txt=35:*.json=35:*.xml=35:*.yml=35:*.toml=35:*.html=35:*.css=35:*LICENSE=35:*README=35:*VERSION=35:*DESCRIPTION=35:*URL=35:*AUTHORS=35:*CHANGES=35:*COPYRIGHT=35'
LS_COLORS+=':*.py=36:*.rb=36:*.sh=36:*.zsh=36:*.bash=36:*.zshrc=36:*.zprofile=36:*.js=36:*.ts=36:*.jsx=36:*.tsx=36:*Makefile=36:*Gemfile=36:*.am=36:*.ac=36'

LS_COLORS+=':*.gitignore=1;30:*.gitmodules=1;30:*.git=1;30:*.editorconfig=1;30:.pam_environment=1;30:.hushlogin=1;30:.zshenv=1;30:*.sudo_as_admin_successful=1;30:.DS_Store=1;30'

LS_COLORS+=':or=30;41:mi=30;41:*.TODO=30;41'
LS_COLORS+=':do=30;43:bd=30;43:cd=30;43:ca=30;43:tw=30;43:ow=30;43:st=30;43'
LS_COLORS+=':su=30;45:sg=30;45'
LS_COLORS+=':pi=30;46:so=30;46'

export LS_COLORS
