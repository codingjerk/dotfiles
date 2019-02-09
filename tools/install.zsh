set -e -o pipefail
export CJ_DOTFILES="${0:a:h:h}"

# === Git submodules ===
cd "${CJ_DOTFILES}"
git submodule update --init

# === Settings ===
if ! [ -e "${CJ_DOTFILES}/settings.sh" ]; then
  "${CJ_DOTFILES}/generate-settings.zsh" > "${CJ_DOTFILES}/settings.sh"
fi

# === Ensure directories exist ===
. "${CJ_DOTFILES}/config/zsh/.zprofile"

mkdir -p "${LESSKEY:h}"
mkdir -p "${TRANSMISSION_HOME}"
mkdir -p "${XDG_DATA_HOME}/minidlna"
mkdir -p "${XDG_DATA_HOME}/i3"
mkdir -p "${XDG_DATA_HOME}/polybar"

mkdir -p "${XDG_DATA_HOME}/gnupg"
mkdir -p "${XDG_DATA_HOME}/zsh"
mkdir -p "${XDG_DATA_HOME}/python"
mkdir -p "${XDG_DATA_HOME}/node"

touch "${XDG_DATA_HOME}/python/history"

# === Dynamic (.in) configs ===
lesskey -o "${LESSKEY}" "${XDG_CONFIG_HOME}/less/lesskey.in"
sh "${XDG_CONFIG_HOME}/zsh/.zshenv.in" > "${HOME}/.zshenv"
sh "${XDG_CONFIG_HOME}/transmission/settings.json.in" > "${TRANSMISSION_HOME}/settings.json"
sh "${XDG_CONFIG_HOME}/minidlna/minidlna.conf.in" > "${XDG_DATA_HOME}/minidlna/minidlna.conf"
sh "${XDG_CONFIG_HOME}/i3/config.in" > "${XDG_DATA_HOME}/i3/config"
sh "${XDG_CONFIG_HOME}/polybar/config.in" > "${XDG_DATA_HOME}/polybar/config"
sh "${XDG_CONFIG_HOME}/xfce4/terminal/terminalrc.in" > "${XDG_CONFIG_HOME}/xfce4/terminal/terminalrc"
sh "${XDG_CONFIG_HOME}/gtk-3.0/gtk.css.in" > "${XDG_CONFIG_HOME}/gtk-3.0/gtk.css"
sh "${XDG_CONFIG_HOME}/zathura/zathurarc.in" > "${XDG_CONFIG_HOME}/zathura/zathurarc"

# === Set access rights ===
chmod -w "${XDG_CONFIG_HOME}/htop/htoprc"
chmod -w "${XDG_CONFIG_HOME}/KeeWeb/app-settings.json"

# === Build suckless ===
. "${CJ_DOTFILES}/settings.sh"
. "${CJ_DOTFILES}/assets/colors.sh"

cd "${CJ_DOTFILES}/third-party/dmenu"
sed -e "s/__COLOR_BG__/${CJ_COLOR_BG_HEX}/g" \
    -e "s/__COLOR_FG__/${CJ_COLOR_FG_HEX}/g" \
    -e "s/__COLOR_AC__/${CJ_COLOR_4_HEX}/g" \
    -e "s/__FONT__/${CJ_MONOFONT}/g" \
    -e "s/__FONT_SIZE__/${CJ_MONOFONT_SIZE}/g" \
    -e "s/__LINE_HEIGHT__/$((${CJ_MONOFONT_SIZE} * 4))/g" \
    config.def.h > config.h

make dmenu CC='cc -w' > /dev/null
cp ./dmenu "${CJ_DOTFILES}/bin"
