setopt ERR_EXIT NO_UNSET PIPE_FAIL

bindkey -e
ask() {
  TEMPVAR="$2"
  vared -p "$1: " -che TEMPVAR
  echo "$TEMPVAR"
}

cat <<EOF
export CJ_MONOFONT='$(ask 'GUI monospace font' 'Fira Code')'
export CJ_MONOFONT_SIZE=$(ask 'Font size' '12')

export CJ_MONITORS="$(ask 'Monitor list' 'HDMI-A-0;eDP')"
export CJ_X_AUTOSTART=$(ask 'Autostart X? (yes/no)' 'yes')
export CJ_WALLPAPER='${CJ_DOTFILES}/assets/wallpaper.png'

export CJ_USE_ZSHENV=$(ask 'Use zshenv instead of pamenv? (yes/no)' 'no')
EOF
