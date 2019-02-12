. "${CJ_DOTFILES}/assets/colors.sh"

# === Functions ===
color_name() {
  echo "$1 : #$2"
}

color_id() {
  local hex=$(printf "%X" "$1")
  eval local color=\${CJ_COLOR_${hex}_HEX}

  color_name "color$1" "$color"
}

# === Colors ===
color_name background "${CJ_COLOR_BG_HEX}"
color_name foreground "${CJ_COLOR_FG_HEX}"

for id in {0..15}; do
  color_id "$id"
done
