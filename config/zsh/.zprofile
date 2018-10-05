python "${DOTFILES_DIR}/tools/motd.py"

# === Tools ===
export EDITOR='vim -p'
export VISUAL="${EDITOR}"
export PAGER='less'

# === Options ===
export PATH='/bin'

export FZF_DEFAULT_OPTS="--color=16 --height=20 --layout=reverse --inline-info --no-mouse --preview-window='left:50%'"

export GREP_COLORS='sl=0:cx=1;30:fn=0;33:ln=0;35'

export LESS='-iMRS -x4 -z-4'
export LESSOPEN=$'|pygmentize -g "%s" | awk \'{printf "\e[1;30m%%5s \e[0m", NR; print $0}\''

# === XDG Base Directory Specification ===
export XDG_CONFIG_HOME="${DOTFILES_DIR}/config"
export XDG_DATA_HOME="${DOTFILES_DIR}/share"
export XDG_CACHE_HOME="${DOTFILES_DIR}/cache"

# === XDG Fixes ===
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
export HISTFILE="${XDG_DATA_HOME}/zsh/history"
