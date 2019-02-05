# === Text functions ===
message() { echo "\033[${1}m[$2]: $3 is $4\033[0m" }
require_message() { message 31 error $1 required }
recommend_message() { message 33 warning $1 recommended }

# === Test functions ===
binary() { (( $+commands[$1] )) }
python_lib() { python -c "import $1" 2> /dev/null }
font() { fc-list | grep -i "$1" > /dev/null 2> /dev/null }
theme() { false }
icons() { false }

# === Dependency declaration functions ===
require() { "$1" "$3" || require_message "$2" }
recommend() { "$1" "$3" || recommend_message "$2" }

# === Strict dependencies ===
require binary "Z shell" zsh
require binary "NeoVim" nvim
require binary "Python (3.x)" python3
require binary "fzf" fzf
require binary "fd" fd

require python_lib "psutil (Python library)" psutil

# === Optional dependencies ===
recommend binary "less" less
recommend binary "tmux" tmux
recommend binary "htop" htop
recommend binary "OpenSSH" ssh
recommend binary "GnuPG" gpg2
recommend binary "exa" exa
recommend binary "hexyl" hexyl

# === Daemons ===
recommend binary "Transmission (daemon)" transmission-daemon
recommend binary "MiniDLNA" minidlnad

# === GUI ===
require font "Fira Mono (font)" "Fira Mono"
require font "Font Awesome (font)" "Awesome"
require font "Noto Sans (font)" "Noto Sans"

require theme "Adapta (theme)" "Adapta"
require icons "Breeze (icons)" "breeze"
require icons "Breeze (cursors)" "breeze_cursors"

require binary "xinit" xinit
require binary "feh" feh
require binary "Polybar" polybar
require binary "i3 (gaps)" i3
require binary "maim" maim
require binary "slop" slop
require binary "ImageMagick" convert

recommend binary "Zathura" zathura
recommend binary "KeeWeb" keeweb
recommend binary "Chromium" chromium
recommend binary "mpv" mpv

# === OS-specfic ===
# = Archlinux =
if test -x '/bin/pacman'; then
  recommend binary "pkgfile" pkgfile
fi

# = Voidlinux =
if test -x '/bin/xbps-query'; then
  recommend binary "xtools" xlocate
fi
