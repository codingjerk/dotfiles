setopt ERR_EXIT NO_UNSET PIPE_FAIL

if ! [[ -v 1 ]]; then
  echo "Usage: check-dependencies.zsh MODE"
  echo "MODE can be opt, gui, vim and/or all"
  exit 1
fi

mode="$1"

if [[ "all" =~ "$mode" ]]; then
  mode="opt,gui,vim"
fi

# === Text functions ===
message() { echo "\033[${1}m[$2]: $3 is $4\033[0m" }
require_message() { message 31 error "$1" required }
recommend_message() { message 33 warning "$1" recommended }

# === Test functions ===
binary() { which "$1" > /dev/null }
python3_lib() { python3 -c "import $1" 2> /dev/null }
python2_lib() { binary python2 && python2 -c "import $1" 2> /dev/null }
consolefont() { test -e "/usr/share/kbd/consolefonts/$1.psf.gz" }
font()  { which fc-list > /dev/null && fc-list | grep -i "$1" > /dev/null 2> /dev/null }
theme() { test -e "/usr/share/themes/$1" }
icons() { test -e "/usr/share/icons/$1" }

# === Dependency declaration functions ===
require() { "$1" "$3" || require_message "$2" }
recommend() { "$1" "$3" || recommend_message "$2" }

# === Strict dependencies ===
require binary "Z shell" zsh
require binary "NeoVim" nvim
require binary "Python (3.x)" python3
require binary "fzf" fzf
require binary "fd" fd

# === Optional dependencies ===
if [[ "$mode" =~ opt ]]; then
  recommend binary "less" less
  recommend binary "man" man
  recommend binary "tmux" tmux
  recommend binary "htop" htop
  recommend binary "OpenSSH" ssh
  recommend binary "GnuPG" gpg2
  recommend binary "GnuPG TTY pinentry" pinentry-tty
  recommend binary "exa" exa
  recommend binary "hexyl" hexyl
  recommend binary "Ripgrep" rg
  recommend binary "mpd" mpd
  recommend binary "pipewire" pipewire
  recommend binary "pavucontrol" pavucontrol
  recommend binary "pass" pass
fi

# === GUI ===
if [[ "$mode" =~ gui ]]; then
  recommend consolefont "Terminus (console font)" "ter-i20n"
  require font "Fira Code (font)" "Fira Code"
  require font "Font Awesome (font)" "Awesome"
  require font "Noto Sans (font)" "Noto Sans"
  require font "Noto Sans CJK (font)" "Noto Sans CJK"
  require font "Noto Color Emoji (font)" "Noto Color Emoji"
  require font "Twitter Color Emoji (font)" "Twitter Color Emoji"

  require theme "Adapta (theme)" "Adapta"
  require icons "Breeze (icons)" "breeze"
  require icons "Breeze (cursors)" "Breeze_Snow"

  require binary "xinit" xinit
  require binary "feh" feh
  require binary "Polybar" polybar
  require binary "Dunst" dunst
  require binary "i3 (gaps)" i3
  require binary "i3lock (color, by PandorasFox)" i3lock
  require binary "RXVT unicode" urxvt
  require binary "Rofi" rofi
  require binary "maim" maim
  require binary "slop" slop
  require binary "ImageMagick" convert

  recommend binary "xclip" xclip

  recommend binary "Zathura" zathura
  recommend binary "Chromium" chromium
  recommend binary "mpv" mpv
  recommend binary "picom" picom
fi

# === Vim-plugin dependencies ===
if [[ "$mode" =~ vim ]]; then
  require python3_lib "neovim (Python library)" neovim
  require binary "Python 2.x" python2
  require python2_lib "neovim (Python 2 library)" neovim
  require binary "Ruby" ruby
  require binary "Node.js" node
  require binary "NPM" npm
fi

# === OS-specfic ===
# = Archlinux =
if test -x "/bin/pacman"; then
  recommend binary "pkgfile" pkgfile
fi

# = Voidlinux =
if test -x "/bin/xbps-query"; then
  recommend binary "xtools" xlocate
fi
