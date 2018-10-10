# === Tools ===
export EDITOR='vim -p'
export VISUAL="${EDITOR}"
export PAGER='less'

# === Options ===
export PATH='/bin'

export FZF_DEFAULT_COMMAND="fd -t f -t l -S-10M -H --color=always -E .git/ -E /etc/ssl -E /sys -E /dev -E /proc -E /opt -E /usr/bin -E /usr/lib -E /usr/lib32 -E /usr/libexec -E /var/cache -E /var/db -E /var/lib -E /usr/src -E /usr/share . /"
export FZF_DEFAULT_OPTS="--ansi --color='16,hl:6,fg+:1,bg+:0,hl+:6,info:2,prompt:2,pointer:1,marker:5' --height=20 --layout=reverse --inline-info --no-mouse"

export GREP_COLORS='sl=0:cx=1;30:fn=0;33:ln=0;35'

export LESS='-iMRS -x4 -z-4'

# === LS_COLORS ===
LS_COLORS="no=0:fi=0:di=34"

LS_COLORS+=":*.c=31:*.rs=31:*.lock=31"
LS_COLORS+=":ex=32:ln=32:*.exe=32:*.cmd=32:*.com=32"

LS_COLORS+=":*.mp3=33:*.wav=33"
LS_COLORS+=":*.png=33:*.jpg=33:*.jpeg=33"
LS_COLORS+=":*.mp4=33:*.mkv=33"

LS_COLORS+=":*.md=35:*.tex=35:*.txt=35:*.json=35:*.xml=35:*.yml=35:*.toml=35:*.html=35:*.css=35:*LICENSE=35:*README=35:*VERSION=35:*DESCRIPTION=35:*URL=35:*AUTHORS=35"
LS_COLORS+=":*.py=36:*.rb=36:*.sh=36:*.zsh=36:*.bash=36:*.zshrc=36:*.zprofile=36:*.zshenv=36:*.js=36:*.ts=36:*Makefile=36:*Gemfile=36"

LS_COLORS+=":*.gitignore=1;30:*.gitmodules=1;30:*.git=1;30:*.editorconfig=1;30"

LS_COLORS+=":or=30;41:mi=30;41:*.TODO=30;41"
LS_COLORS+=":do=30;43:bd=30;43:cd=30;43:ca=30;43:tw=30;43:ow=30;43:st=30;43"
LS_COLORS+=":su=30;45:sg=30;45"
LS_COLORS+=":pi=30;46:so=30;46"

export LS_COLORS

# === XDG Base Directory Specification ===
export XDG_CONFIG_HOME="${DOTFILES_DIR}/config"
export XDG_DATA_HOME="${DOTFILES_DIR}/share"
export XDG_CACHE_HOME="${DOTFILES_DIR}/cache"
export XDG_RUNTIME_DIR="${DOTFILES_DIR}/runtime"

# === XDG Fixes ===
export LESSHISTFILE="${XDG_DATA_HOME}/less/history"
export LESSKEY="${XDG_CONFIG_HOME}/less/lesskey"

export TMUX_TMPDIR="${XDG_RUNTIME_DIR}"

export VIMINIT=":source ${XDG_CONFIG_HOME}/nvim/init.vim"

export XLOCATE_GIT="${XDG_CACHE_HOME}/xlocate"

export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
export HISTFILE="${XDG_DATA_HOME}/zsh/history"

# === Autolaod ===
if tty | grep tty > /dev/null; then
  sh "${DOTFILES_DIR}/tools/tty-colors.sh"
  clear
fi

if [[ -z "$TMUX" ]]; then
  python "${DOTFILES_DIR}/tools/motd.py"
fi
