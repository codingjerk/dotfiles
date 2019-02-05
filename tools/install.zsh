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

echo 'Edit settings file and press return...'
read __UNUSED_ANSWER
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
chmod -w "${XDG_CONFIG_HOME}/KeeWeb/app-settings.json"

mkdir -p "${TRANSMISSION_HOME}"
sh "${XDG_CONFIG_HOME}/transmission/settings.json.in" > "${TRANSMISSION_HOME}/settings.json"
mkdir -p "${XDG_DATA_HOME}/minidlna"
sh "${XDG_CONFIG_HOME}/minidlna/minidlna.conf.in" > "${XDG_DATA_HOME}/minidlna/minidlna.conf"
mkdir -p "${XDG_DATA_HOME}/i3"
sh "${XDG_CONFIG_HOME}/i3/config.in" > "${XDG_DATA_HOME}/i3/config"
mkdir -p "${XDG_DATA_HOME}/polybar"
sh "${XDG_CONFIG_HOME}/polybar/config.in" > "${XDG_DATA_HOME}/polybar/config"

# === Dirs needed to exist ===
mkdir -p "${XDG_DATA_HOME}/gnupg"
mkdir -p "${XDG_DATA_HOME}/zsh"
mkdir -p "${XDG_DATA_HOME}/python"
touch "${XDG_DATA_HOME}/python/history"
mkdir -p "${XDG_DATA_HOME}/node"

# === Git submodules ===
cd ${DOTFILES_DIR}
git submodule update --init --recursive

# === Suckless ===
. "${DOTFILES_DIR}/assets/colors.sh"

cd "${DOTFILES_DIR}/third-party/dmenu"
sed -e "s/__COLOR_BG__/${CJ_COLOR_BG_HEX}/g" \
    -e "s/__COLOR_FG__/${CJ_COLOR_FG_HEX}/g" \
    -e "s/__COLOR_AC__/${CJ_COLOR_4_HEX}/g" \
    -e "s/__FONT__/${FONT}/g" \
    -e "s/__FONT_SIZE__/${FONT_SIZE}/g" \
    -e "s/__LINE_HEIGHT__/$((${PANEL_SIZE} * 3 / 2))/g" \
    config.def.h > config.h

make
cp ./dmenu "${DOTFILES_DIR}/bin"

cd "${DOTFILES_DIR}/third-party/st"
sed -e "s/__COLOR_0__/${CJ_COLOR_0_HEX}/g" \
    -e "s/__COLOR_1__/${CJ_COLOR_1_HEX}/g" \
    -e "s/__COLOR_2__/${CJ_COLOR_2_HEX}/g" \
    -e "s/__COLOR_3__/${CJ_COLOR_3_HEX}/g" \
    -e "s/__COLOR_4__/${CJ_COLOR_4_HEX}/g" \
    -e "s/__COLOR_5__/${CJ_COLOR_5_HEX}/g" \
    -e "s/__COLOR_6__/${CJ_COLOR_6_HEX}/g" \
    -e "s/__COLOR_7__/${CJ_COLOR_7_HEX}/g" \
    -e "s/__COLOR_8__/${CJ_COLOR_8_HEX}/g" \
    -e "s/__COLOR_9__/${CJ_COLOR_9_HEX}/g" \
    -e "s/__COLOR_A__/${CJ_COLOR_A_HEX}/g" \
    -e "s/__COLOR_B__/${CJ_COLOR_B_HEX}/g" \
    -e "s/__COLOR_C__/${CJ_COLOR_C_HEX}/g" \
    -e "s/__COLOR_D__/${CJ_COLOR_D_HEX}/g" \
    -e "s/__COLOR_E__/${CJ_COLOR_E_HEX}/g" \
    -e "s/__COLOR_F__/${CJ_COLOR_F_HEX}/g" \
    -e "s/__FONT__/${FONT}/g" \
    -e "s/__FONT_SIZE__/${FONT_SIZE}/g" \
    -e "s/__BORDER_SIZE__/$((${PANEL_SIZE} * 3 / 4))/g" \
    config.def.h > config.h

make
cp ./st "${DOTFILES_DIR}/bin"

# === Void linux ===
test -x '/bin/xlocate' && xlocate -S

# === Arch linux ===
test -x '/bin/pacman' && echo '[note]: update pkgfile database'
