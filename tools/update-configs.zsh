setopt ERR_EXIT NO_UNSET PIPE_FAIL

# === Ensure directories exist ===
mkdir -p "${LESSKEY:h}"
mkdir -p "${XDG_RUNTIME_DIR}"

mkdir -p "${XDG_DATA_HOME}/gnupg"
mkdir -p "${XDG_DATA_HOME}/zsh"
mkdir -p "${XDG_DATA_HOME}/python"
mkdir -p "${XDG_DATA_HOME}/node"
mkdir -p "${XDG_CACHE_HOME}/zsh"

touch "${XDG_DATA_HOME}/python/history"

# === Set access rights ===
chmod -w "${XDG_CONFIG_HOME}/htop/htoprc"
chmod -w "${XDG_CONFIG_HOME}/KeeWeb/app-settings.json"

# === Update *.in configs ===
lesskey -o "${LESSKEY}" "${XDG_CONFIG_HOME}/less/lesskey.in"
sh "${XDG_CONFIG_HOME}/zsh/.zshenv.in" > "${HOME}/.zshenv"
sh "${XDG_CONFIG_HOME}/i3/config.in" > "${XDG_CONFIG_HOME}/i3/config"
sh "${XDG_CONFIG_HOME}/polybar/config.in" > "${XDG_CONFIG_HOME}/polybar/config"
sh "${XDG_CONFIG_HOME}/xfce4/terminal/terminalrc.in" > "${XDG_CONFIG_HOME}/xfce4/terminal/terminalrc"
sh "${XDG_CONFIG_HOME}/gtk-3.0/gtk.css.in" > "${XDG_CONFIG_HOME}/gtk-3.0/gtk.css"
sh "${XDG_CONFIG_HOME}/zathura/zathurarc.in" > "${XDG_CONFIG_HOME}/zathura/zathurarc"
