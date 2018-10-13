DOTFILES_DIR="${PWD}/$(dirname "$(dirname "$0")")"

cat <<EOF > "${HOME}/.zshenv"
export DOTFILES_DIR='${DOTFILES_DIR}'
export ZDOTDIR='${DOTFILES_DIR}/config/zsh'
EOF

lesskey -o "${LESSKEY}" "${LESSKEY}.in"
chmod -w "${XDG_CONFIG_HOME}/htop/htoprc"

sh "${XDG_CONFIG_HOME}/transmission/settings.json.in" > "${TRANSMISSION_HOME}/settings.json"

# === Void linux ===
test -x '/usr/bin/xlocate' && xlocate -S
