set -e -o pipefail
export CJ_DOTFILES="${0:a:h:h}"

# === Git submodules ===
cd "${CJ_DOTFILES}"
git submodule update --init > /dev/null

# === Settings ===
if ! [ -e "${CJ_DOTFILES}/settings.sh" ]; then
  zsh "${CJ_DOTFILES}/tools/generate-settings.zsh" > "${CJ_DOTFILES}/settings.sh"
fi

# === Update configs ===
. "${CJ_DOTFILES}/config/zsh/.zprofile"
zsh "${CJ_DOTFILES}/tools/update-configs.zsh"
