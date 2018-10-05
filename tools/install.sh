DOTFILES_DIR="$PWD/$(dirname "$(dirname "$0")")"

cat <<EOF > "${HOME}/.zshenv"
export DOTFILES_DIR='${DOTFILES_DIR}'
export ZDOTDIR='${DOTFILES_DIR}/config/zsh'
EOF
