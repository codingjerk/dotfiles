setopt ERR_EXIT NO_UNSET PIPE_FAIL

bindkey -e
ask() {
  TEMPVAR="$2"
  vared -p "$1: " -che TEMPVAR
  echo "$TEMPVAR"
}

cat <<EOF
export CJ_MONOFONT='$(ask 'GUI monospace font' 'Hack')'
export CJ_MONOFONT_SIZE=$(ask 'Font size' '12')

export CJ_MONITORS="$(ask 'Monitor list' 'HDMI-A-0;eDP')"
export CJ_X_AUTOSTART=$(ask 'Autostart X? (yes/no)' 'yes')
export CJ_WALLPAPER='${CJ_DOTFILES}/assets/wallpaper-$(ask 'Wallpaper variant (railroad.png, forest-2.jpg, keyboard.jpg)' 'keyboard.jpg')'
EOF
