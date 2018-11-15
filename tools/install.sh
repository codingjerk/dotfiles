# === Basics ===
export DOTFILES_DIR="${PWD}/$(dirname "$(dirname "$0")")"

. "${DOTFILES_DIR}/config/zsh/.zprofile"

# === Settings ===
if ! [ -e "${DOTFILES_DIR}/settings.sh" ]; then
cat <<EOF > "${DOTFILES_DIR}/settings.sh"
export FONT='Fira Mono'
export FONT_SIZE=12
export PANEL_SIZE=32
export X_PRIMARY_MONITOR=DRY
export X_SECONDARY_MONITOR=DIY
export X_AUTOSTART=yes
export X_WALLPAPER='${DOTFILES_DIR}/assets/wallpaper-RES.png'
EOF
fi

read -p 'Edit settings file and press return...'
. "${DOTFILES_DIR}/settings.sh"

# === .zshenv ===
cat <<EOF > "${HOME}/.zshenv"
export DOTFILES_DIR='${DOTFILES_DIR}'
export ZDOTDIR='${DOTFILES_DIR}/config/zsh'

export X_AUTOSTART='${X_AUTOSTART}'
export X_WALLPAPER='${X_WALLPAPER}'

export X_PRIMARY_MONITOR='${X_PRIMARY_MONITOR}'
export X_SECONDARY_MONITOR='${X_SECONDARY_MONITOR}'
EOF

# === Dynamic (.in) configs ===
mkdir -p "$(dirname "${LESSKEY}")"
lesskey -o "${LESSKEY}" "${XDG_CONFIG_HOME}/less/lesskey.in"
chmod -w "${XDG_CONFIG_HOME}/htop/htoprc"

mkdir -p "${TRANSMISSION_HOME}"
sh "${XDG_CONFIG_HOME}/transmission/settings.json.in" > "${TRANSMISSION_HOME}/settings.json"
mkdir -p "${XDG_DATA_HOME}/minidlna"
sh "${XDG_CONFIG_HOME}/minidlna/minidlna.conf.in" > "${XDG_DATA_HOME}/minidlna/minidlna.conf"
mkdir -p "${XDG_DATA_HOME}/i3"
sh "${XDG_CONFIG_HOME}/i3/config.in" > "${XDG_DATA_HOME}/i3/config"
mkdir -p "${XDG_DATA_HOME}/polybar"
sh "${XDG_CONFIG_HOME}/polybar/config.in" > "${XDG_DATA_HOME}/polybar/config"

# === Git submodules
cd ${DOTFILES_DIR}
git submodule update --init --recursive

# === Dependencies ===
require_message() {
  echo $'\E[31m' "[warning]: $1 is required" $'\E[0m'
}

require() {
  test -x "/bin/$1" || require_message "$1"
}

require_python() {
  test -x '/bin/python3' || return
  python3 -c "import $1" 2> /dev/null || require_message "$1 (python library)"
}

recommend() {
  test -x "/bin/$1" || echo $'\E[33m' "[warning]: $1 is recommended" $'\E[0m'
}

require zsh
require nvim
require python3
  require_python psutil
require fzf
require fd

# === Optionalies ===
recommend less
recommend tmux
recommend htop
recommend ssh
recommend gpg2
recommend exa
recommend hexyl
recommend transmission-daemon
recommend minidlnad

# === GUI dependencies ===
fc-list | grep -i "fira mono" > /dev/null 2> /dev/null || require_message "Fira Mono (font)"
fc-list | grep -i "font awesome" > /dev/null 2> /dev/null || require_message "Font Awesome (font)"

require xinit
require feh
require polybar
require i3

# === Void linux ===
test -x '/bin/xlocate' && xlocate -S
