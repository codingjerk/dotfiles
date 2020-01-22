setopt ERR_EXIT NO_UNSET PIPE_FAIL

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
lesskey -o "${XDG_CONFIG_HOME}/less/lesskey" "${XDG_CONFIG_HOME}/less/lesskey.in"
sh "${XDG_CONFIG_HOME}/pam/environment.in" > "${HOME}/.pam_environment"
sh "${XDG_CONFIG_HOME}/i3/config.in" > "${XDG_CONFIG_HOME}/i3/config"
sh "${XDG_CONFIG_HOME}/polybar/config.in" > "${XDG_CONFIG_HOME}/polybar/config"
sh "${XDG_CONFIG_HOME}/alacritty/alacritty.yml.in" > "${XDG_CONFIG_HOME}/alacritty/alacritty.yml"
sh "${XDG_CONFIG_HOME}/gtk-3.0/gtk.css.in" > "${XDG_CONFIG_HOME}/gtk-3.0/gtk.css"
sh "${XDG_CONFIG_HOME}/zathura/zathurarc.in" > "${XDG_CONFIG_HOME}/zathura/zathurarc"

# === Os-specific steps ===

# == Termux ==
[ -d ~/.termux ] && sh "${XDG_CONFIG_HOME}/termux/colors.in" > ~/.termux/colors.properties
[ -d ~/.termux ] && cp "${XDG_CONFIG_HOME}/termux/config" ~/.termux/termux.properties
[ -d ~/.termux ] && cp "${CJ_DOTFILES}/assets/font-hack.ttf" ~/.termux/font.ttf
