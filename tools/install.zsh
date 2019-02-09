# === Basics ===
export CJ_DOTFILES="${PWD}/$(dirname "$(dirname "$0")")"

. "${CJ_DOTFILES}/config/zsh/.zprofile"

# === Settings ===
if ! [ -e "${CJ_DOTFILES}/settings.sh" ]; then
cat <<EOF > "${CJ_DOTFILES}/settings.sh"
export CJ_MONOFONT='Fira Mono'
export CJ_MONOFONT_SIZE=12
export PANEL_SIZE=32
export X_PRIMARY_MONITOR=DRY
export X_SECONDARY_MONITOR=DIY
export X_AUTOSTART=yes
export X_WALLPAPER='${CJ_DOTFILES}/assets/wallpaper-RES.png'
EOF
fi

echo 'Edit settings file and press return...'
read __UNUSED_ANSWER
. "${CJ_DOTFILES}/settings.sh"

# === .zshenv ===
cat <<EOF > "${HOME}/.zshenv"
export CJ_DOTFILES='${CJ_DOTFILES}'
export ZDOTDIR='${CJ_DOTFILES}/config/zsh'

export X_AUTOSTART='${X_AUTOSTART}'
export X_WALLPAPER='${X_WALLPAPER}'

export X_PRIMARY_MONITOR='${X_PRIMARY_MONITOR}'
export X_SECONDARY_MONITOR='${X_SECONDARY_MONITOR}'
EOF

# === Dynamic (.in) configs ===
mkdir -p "$(dirname "${LESSKEY}")"
lesskey -o "${LESSKEY}" "${XDG_CONFIG_HOME}/less/lesskey.in"

chmod -w "${XDG_CONFIG_HOME}/htop/htoprc"
chmod -w "${XDG_CONFIG_HOME}/KeeWeb/app-settings.json"

mkdir -p "${TRANSMISSION_HOME}"
sh "${XDG_CONFIG_HOME}/transmission/settings.json.in" > "${TRANSMISSION_HOME}/settings.json"
mkdir -p "${XDG_DATA_HOME}/minidlna"
sh "${XDG_CONFIG_HOME}/minidlna/minidlna.conf.in" > "${XDG_DATA_HOME}/minidlna/minidlna.conf"
mkdir -p "${XDG_DATA_HOME}/i3"
sh "${XDG_CONFIG_HOME}/i3/config.in" > "${XDG_DATA_HOME}/i3/config"
mkdir -p "${XDG_DATA_HOME}/polybar"
sh "${XDG_CONFIG_HOME}/polybar/config.in" > "${XDG_DATA_HOME}/polybar/config"
sh "${XDG_CONFIG_HOME}/xfce/terminal/terminalrc.in" > "${XDG_CONFIG_HOME}/xfce/terminal/terminalrc"
sh "${XDG_CONFIG_HOME}/gtk-3.0/gtk.css.in" > "${XDG_CONFIG_HOME}/gtk-3.0/gtk.css"
sh "${XDG_CONFIG_HOME}/zathura/zathurarc.in" > "${XDG_CONFIG_HOME}/zathura/zathurarc"

# === Dirs needed to exist ===
mkdir -p "${XDG_DATA_HOME}/gnupg"
mkdir -p "${XDG_DATA_HOME}/zsh"
mkdir -p "${XDG_DATA_HOME}/python"
touch "${XDG_DATA_HOME}/python/history"
mkdir -p "${XDG_DATA_HOME}/node"

# === Git submodules ===
cd ${CJ_DOTFILES}
git submodule update --init --recursive

# === Suckless ===
. "${CJ_DOTFILES}/assets/colors.sh"

cd "${CJ_DOTFILES}/third-party/dmenu"
sed -e "s/__COLOR_BG__/${CJ_COLOR_BG_HEX}/g" \
    -e "s/__COLOR_FG__/${CJ_COLOR_FG_HEX}/g" \
    -e "s/__COLOR_AC__/${CJ_COLOR_4_HEX}/g" \
    -e "s/__FONT__/${CJ_MONOFONT}/g" \
    -e "s/__FONT_SIZE__/${CJ_MONOFONT_SIZE}/g" \
    -e "s/__LINE_HEIGHT__/$((${PANEL_SIZE} * 3 / 2))/g" \
    config.def.h > config.h

make
cp ./dmenu "${CJ_DOTFILES}/bin"

# === Void linux ===
test -x '/bin/xlocate' && xlocate -S

# === Arch linux ===
test -x '/bin/pacman' && echo '[note]: update pkgfile database'
