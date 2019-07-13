setopt ERR_EXIT NO_UNSET PIPE_FAIL

export CJ_DOTFILES="${0:a:h:h}"
export XDG_CONFIG_HOME="${CJ_DOTFILES}/config"
export XDG_DATA_HOME="${CJ_DOTFILES}/share"
export XDG_CACHE_HOME="${CJ_DOTFILES}/cache"
export XDG_RUNTIME_DIR="${CJ_DOTFILES}/runtime"

# === Git submodules ===
cd "${CJ_DOTFILES}"
git submodule update --init --quiet

# === Settings ===
if ! [ -e "${CJ_DOTFILES}/settings.sh" ]; then
  zsh "${CJ_DOTFILES}/tools/generate-settings.zsh" > "${CJ_DOTFILES}/settings.sh"
fi

# === Update configs ===
. "${CJ_DOTFILES}/config/zsh/.zprofile"
zsh "${CJ_DOTFILES}/tools/update-configs.zsh"

vared -p "Do you want to install root configs? [y/N]: " -che ANSWER || ANSWER=n
if [[ "$ANSWER" = "y" ]]; then
  sudo zsh "${CJ_DOTFILES}/tools/update-system-configs.zsh"
fi
