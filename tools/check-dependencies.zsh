# === Text functions ===
message() { echo "\033[${1}m[$2]: $3 is $4\033[0m" }
require_message() { message 31 error "$1" required }
recommend_message() { message 33 warning "$1" recommended }

# === Test functions ===
binary() { which "$1" > /dev/null }
python3_lib() { python3 -c "import $1" 2> /dev/null }
consolefont() { test -e "/usr/share/kbd/consolefonts/$1.psf.gz" }
font() { which fc-list > /dev/null && fc-list | grep -i "$1" > /dev/null 2> /dev/null }
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

require python3_lib "psutil (Python library)" psutil
require python3_lib "neovim (Python library)" neovim
require python3_lib "uptime (Python library)" uptime

# === Optional dependencies ===
recommend consolefont "Terminus (console font)" "ter-i20n"
recommend binary "less" less
recommend binary "tmux" tmux
recommend binary "htop" htop
recommend binary "OpenSSH" ssh
recommend binary "GnuPG" gpg2
recommend binary "exa" exa
recommend binary "hexyl" hexyl
recommend binary "The Silver Searcher" ag

# === Daemons ===
recommend binary "Transmission (daemon)" transmission-daemon
recommend binary "MiniDLNA" minidlnad

# === GUI ===
require font "Fira Mono (font)" "Fira Mono"
require font "Font Awesome (font)" "Awesome"
require font "Noto Sans (font)" "Noto Sans"
require font "Noto Sans CJK (font)" "Noto Sans CJK"
require font "Noto Color Emoji (font)" "Noto Color Emoji"
require font "Twitter Color Emoji (font)" "Twitter Color Emoji"

require theme "Adapta (theme)" "Adapta"
require icons "Breeze (icons)" "breeze"
require icons "Breeze (cursors)" "breeze_cursors"

require binary "xinit" xinit
require binary "feh" feh
require binary "Polybar" polybar
require binary "i3 (gaps)" i3
require binary "i3lock (color)" i3lock
require binary "Xfce Terminal" xfce4-terminal
require binary "maim" maim
require binary "slop" slop
require binary "ImageMagick" convert

recommend binary "Zathura" zathura
recommend binary "KeeWeb" keeweb
recommend binary "Chromium" chromium
recommend binary "mpv" mpv

# === OS-specfic ===
# = Archlinux =
if test -x "/bin/pacman"; then
  recommend binary "pkgfile" pkgfile
fi

# = Voidlinux =
if test -x "/bin/xbps-query"; then
  recommend binary "xtools" xlocate
fi
