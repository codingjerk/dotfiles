setopt ERR_EXIT NO_UNSET PIPE_FAIL

. "${CJ_DOTFILES}/assets/colors.sh"
. "${CJ_DOTFILES}/settings.sh"

# === Functions ===
color() {
  echo "$1=$(printf "%d,%d,%d" ${=2})"
}

color_pair() {
  color "$1" "$2"
  color "Bold$1" "$2"
}

# === Config ===
echo "BoldAsFont=no"
echo "BoldAsColour=yes"
echo "Font=${CJ_MONOFONT}"
echo "FontHeight=${CJ_MONOFONT_SIZE}"

# === Colors ===
color "BackgroundColour" "${CJ_COLOR_BG}"
color "ForegroundColour" "${CJ_COLOR_FG}"
color "CursorColour" "${CJ_COLOR_FG}"

color "Black" "${CJ_COLOR_0}"
color "BoldBlack" "${CJ_COLOR_8}"
color "White" "${CJ_COLOR_7}"
color "BoldWhite" "${CJ_COLOR_F}"

color_pair "Red" "${CJ_COLOR_RED}"
color_pair "Green" "${CJ_COLOR_GREEN}"
color_pair "Yellow" "${CJ_COLOR_YELLOW}"
color_pair "Blue" "${CJ_COLOR_BLUE}"
color_pair "Magenta" "${CJ_COLOR_ORANGE}"
color_pair "Cyan" "${CJ_COLOR_ELECTRIC}"
