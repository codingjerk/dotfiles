# === Basics ===
DOTFILES_DIR="${PWD}/$(dirname "$(dirname "$0")")"

. "${DOTFILES_DIR}/config/zsh/.zprofile"

# === .zshenv ===
cat <<EOF > "${HOME}/.zshenv"
export DOTFILES_DIR='${DOTFILES_DIR}'
export ZDOTDIR='${DOTFILES_DIR}/config/zsh'
EOF

# === Dynamic (.in) configs ===
lesskey -o "${LESSKEY}" "${LESSKEY}.in"
chmod -w "${XDG_CONFIG_HOME}/htop/htoprc"

sh "${XDG_CONFIG_HOME}/transmission/settings.json.in" > "${TRANSMISSION_HOME}/settings.json"

sh "${XDG_CONFIG_HOME}/minidlna/minidlna.conf.in" > "${XDG_DATA_HOME}/minidlna/minidlna.conf"

# === Git submodules
cd ${DOTFILES_DIR}
git submodule init
git submodule update

# === Dependencies ===
test -x '/bin/zsh' || echo $'\E[31m[warning]: zsh is required\E[0m'
test -x '/bin/python3' || echo $'\E[31m[warning]: python (3.x) is required\E[0m'
test -x '/bin/fzf' || echo $'\E[31m[warning]: fzf is required\E[0m'
test -x '/bin/fd' || echo $'\E[31m[warning]: fd is required\E[0m'

if test -x '/bin/python3'; then
  python3 -c 'import psutil' 2> /dev/null || echo $'\E[31m[warning]: psutil (python library) is required\E[0m'
fi

# === Optionalies ===
test -x '/bin/less' || echo $'\E[33m[warning]: less is recommended\E[0m'
test -x '/bin/tmux' || echo $'\E[33m[warning]: tmux is recommended\E[0m'
test -x '/bin/htop' || echo $'\E[33m[warning]: htop is recommended\E[0m'
test -x '/bin/transmission-daemon' || echo $'\E[33m[warning]: transmission (daemon) is recommended\E[0m'
test -x '/bin/minidlnad' || echo $'\E[33m[warning]: minidlna is recommended\E[0m'

# === Void linux ===
test -x '/bin/xlocate' && xlocate -S
