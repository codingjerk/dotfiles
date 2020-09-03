#!/usr/bin/env sh

common_install_pre() {
  git clone "https://gitlab.com/codingjerk/dotfiles" "${HOME}/dotfiles"

  cat > "${HOME}/postinstall.zsh" <<EOF
  echo "Running postinstall.zsh in interactive login zsh session..."
  rm "${HOME}/postinstall.zsh"
EOF
}

common_install_post() {
  zsh "${HOME}/dotfiles/tools/install.zsh"
  zsh "${HOME}/dotfiles/tools/generate-zshenv.zsh" > "${HOME}/.zshenv"

  cat >> "${HOME}/postinstall.zsh" <<EOF
  sudo chsh -s /bin/zsh "$USER"
  nvim +PlugInstall +qall
  ssh-keygen
EOF

  zsh --login --interactive "${HOME}/postinstall.zsh"
}

wsl_packages() {
  sudo apt update
  sudo apt install -y clang python zsh neovim python3 python3-neovim curl less man-db tmux htop ssh gnupg2 pinentry-tty python3-pip pass

  # Static binaries
  curl "https://gitlab.com/codingjerk/dotfiles/uploads/9b2febf821cd2c722f26b61cb879672a/exa" > "${HOME}/dotfiles/bin/exa"
  curl "https://gitlab.com/codingjerk/dotfiles/uploads/9f31083f6a54ed232c21f3485690d4ee/fd" > "${HOME}/dotfiles/bin/fd"
  curl "https://gitlab.com/codingjerk/dotfiles/uploads/61c9d40a257c6a5f68e64490e35c43b1/fzf" > "${HOME}/dotfiles/bin/fzf"

  chmod +x "${HOME}/dotfiles/bin/exa"
  chmod +x "${HOME}/dotfiles/bin/fd"
  chmod +x "${HOME}/dotfiles/bin/fzf"

  # Rust
  cat >> "${HOME}/postinstall.zsh" <<EOF
  \curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- --no-modify-path
  cargo install hexyl
  cargo install ripgrep
EOF

  # WSL TTY config
  cat >> "${HOME}/postinstall.zsh" <<EOF
  mkdir "/mnt/c/Users/${USER}/AppData/Roaming/wsltty"
  zsh "${HOME}/dotfiles/config/mintty/config.in" > "/mnt/c/Users/${USER}/AppData/Roaming/wsltty/config"
EOF
}

ubuntu_packages() {
  sudo apt update
  sudo apt install -y clang python zsh neovim python3 python3-neovim curl less man-db tmux htop ssh gnupg2 pinentry-tty python3-pip pass

  # Static binaries
  curl "https://gitlab.com/codingjerk/dotfiles/uploads/61c9d40a257c6a5f68e64490e35c43b1/fzf" > "${HOME}/dotfiles/bin/fzf"
  chmod +x "${HOME}/dotfiles/bin/fzf"

  # Rust
  cat >> "${HOME}/postinstall.zsh" <<EOF
  \curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- --no-modify-path
  cargo install hexyl
  cargo install ripgrep
  cargo install exa
  cargo install fd-find
EOF
}

arch_packages() {
  sudo pacman -Syu
  sudo pacman -S --noconfirm clang python zsh neovim python3 python3-neovim curl less man-db tmux htop ssh gnupg2 pinentry-tty python3-pip pass pass-otp fzf

  # Rust
  cat >> "${HOME}/postinstall.zsh" <<EOF
  \curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- --no-modify-path
  cargo install hexyl
  cargo install ripgrep
  cargo install exa
  cargo install fd-find
EOF
}

install_with() {
  common_install_pre
  "$1"
  common_install_post
  echo "Installation was finished. Check output for errors"
}

if grep -q Microsoft /proc/version; then
  install_with wsl_packages
elif grep -q Ubuntu /proc/version; then
  install_with ubuntu_packages
elif grep -q Arch /proc/version; then
  install_with arch_packages
else
  echo "Error: Unknown OS, can't install"
  exit 1
fi
