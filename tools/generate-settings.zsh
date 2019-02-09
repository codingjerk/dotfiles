bindkey -e
ask() {
  TEMPVAR="$2"
  vared -p "$1: " -che TEMPVAR
  echo $TEMPVAR
}

cat <<EOF
export CJ_MONOFONT='$(ask 'GUI monospace font' 'Fira Mono')'
export CJ_MONOFONT_SIZE=$(ask 'Font size' '12')

export CJ_PRIMARY_MONITOR=$(ask 'Primary monitor' 'DRY')
export CJ_SECONDARY_MONITOR=$(ask 'Secondary monitor' 'DIY')
export CJ_X_AUTOSTART=$(ask 'Autostart X? (yes/no)' 'yes')
export CJ_WALLPAPER='${CJ_DOTFILES}/assets/wallpaper-$(ask 'Wallpaper resolution' '1920x1080').png'
EOF
