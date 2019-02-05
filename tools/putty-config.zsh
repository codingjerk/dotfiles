. "${DOTFILES_DIR}/assets/colors.sh"

# === Functions ===
param() {
  echo "\"$1\"=$2"
}

color() {
  param "Colour$1" "\"$2,$3,$4\""
}

color_pair() {
  color $1 $3 $4 $5
  color $2 $3 $4 $5
}

# === Header ===
echo "Windows Registry Editor Version 5.00"
echo ""
echo "[HKEY_CURRENT_USER\\Software\\SimonTatham\\PuTTY\\Sessions\\CJ]"

# === Options ===
param WindowBorder dword:00000010
param HideMousePtr dword:00000001
param WarnOnClose dword:00000000

param Font '"Fira Mono"'
param FontHeight dword:0000000c

# === Colors ===
# Foreground / Background
eval color_pair 0 1 ${CJ_COLOR_FG}
eval color_pair 2 3 ${CJ_COLOR_BG}

# Cursor
eval color 4 ${CJ_COLOR_BG}
eval color 5 ${CJ_COLOR_FG}

# Black / Gray
eval color  6 ${CJ_COLOR_0}
eval color  7 ${CJ_COLOR_8}

# Red
eval color  8 ${CJ_COLOR_1}
eval color  9 ${CJ_COLOR_9}

# Green
eval color 10 ${CJ_COLOR_2}
eval color 11 ${CJ_COLOR_A}

# Yellow
eval color 12 ${CJ_COLOR_3}
eval color 13 ${CJ_COLOR_B}

# Blue
eval color 14 ${CJ_COLOR_4}
eval color 15 ${CJ_COLOR_C}

# Orange
eval color 16 ${CJ_COLOR_5}
eval color 17 ${CJ_COLOR_D}

# Electric
eval color 18 ${CJ_COLOR_6}
eval color 19 ${CJ_COLOR_E}

# Gray / White
eval color 20 ${CJ_COLOR_7}
eval color 21 ${CJ_COLOR_F}
