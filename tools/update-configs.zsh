setopt ERR_EXIT NO_UNSET PIPE_FAIL

# === Load settings ===

export CJ_DOTFILES="${0:a:h:h}"
. "${CJ_DOTFILES}/settings.sh"

# === Ensure directories exist ===
mkdir -p "${XDG_RUNTIME_DIR}"

mkdir -p "${XDG_DATA_HOME}/gnupg"
mkdir -p "${XDG_DATA_HOME}/zsh"
mkdir -p "${XDG_DATA_HOME}/python"
mkdir -p "${XDG_DATA_HOME}/node"
mkdir -p "${XDG_DATA_HOME}/postgres"
mkdir -p "${XDG_CACHE_HOME}/zsh"

touch "${XDG_DATA_HOME}/node/history"

# === Set access rights ===
chmod ugo-w "${XDG_CONFIG_HOME}/htop/htoprc"
chmod go-rwx "${XDG_DATA_HOME}/gnupg"

# === Update *.in configs ===
lesskey -o "${XDG_CONFIG_HOME}/less/lesskey" "${XDG_CONFIG_HOME}/less/lesskey.in" 2> /dev/null
sh "${XDG_CONFIG_HOME}/i3/config.in" > "${XDG_CONFIG_HOME}/i3/config"
sh "${XDG_CONFIG_HOME}/sway/config.in" > "${XDG_CONFIG_HOME}/sway/config"
sh "${XDG_CONFIG_HOME}/swaylock/config.in" > "${XDG_CONFIG_HOME}/swaylock/config"
sh "${XDG_CONFIG_HOME}/foot/foot.ini.in" > "${XDG_CONFIG_HOME}/foot/foot.ini"
sh "${XDG_CONFIG_HOME}/mako/config.in" > "${XDG_CONFIG_HOME}/mako/config"
sh "${XDG_CONFIG_HOME}/fuzzel/fuzzel.ini.in" > "${XDG_CONFIG_HOME}/fuzzel/fuzzel.ini"
sh "${XDG_CONFIG_HOME}/polybar/config.in" > "${XDG_CONFIG_HOME}/polybar/config"
sh "${XDG_CONFIG_HOME}/dunst/config.in" > "${XDG_CONFIG_HOME}/dunst/dunstrc"
sh "${XDG_CONFIG_HOME}/alacritty/alacritty.yml.in" > "${XDG_CONFIG_HOME}/alacritty/alacritty.yml"
sh "${XDG_CONFIG_HOME}/helix/themes/cj.toml.in" > "${XDG_CONFIG_HOME}/helix/themes/cj.toml"
sh "${XDG_CONFIG_HOME}/urxvt/config.in" > "${XDG_CONFIG_HOME}/urxvt/config"
sh "${XDG_CONFIG_HOME}/gtk-3.0/gtk.css.in" > "${XDG_CONFIG_HOME}/gtk-3.0/gtk.css"
sh "${XDG_CONFIG_HOME}/zathura/zathurarc.in" > "${XDG_CONFIG_HOME}/zathura/zathurarc"

# === Environment file ===
if [[ "${CJ_USE_ZSHENV}" == "yes" ]]; then
  sh "${XDG_CONFIG_HOME}/pam/environment.in" | zsh "${CJ_DOTFILES}/tools/generate-zshenv.zsh" > ~/.zshenv
else
  sh "${XDG_CONFIG_HOME}/pam/environment.in" > "${HOME}/.pam_environment"
fi

# === Os-specific steps ===

# == Termux ==
if [ -d ~/.termux ]; then
  sh "${XDG_CONFIG_HOME}/termux/colors.in" > ~/.termux/colors.properties
  cp "${XDG_CONFIG_HOME}/termux/config" ~/.termux/termux.properties
  cp "${CJ_DOTFILES}/assets/font-hack.ttf" ~/.termux/font.ttf
fi

# == WSL ==
WSLTTY_DIR="/mnt/c/Users/${USER:=}/AppData/Roaming/wsltty"
if [ -d "${WSLTTY_DIR}" ]; then
  zsh "${XDG_CONFIG_HOME}/mintty/config.in" > "${WSLTTY_DIR}/config"
fi
