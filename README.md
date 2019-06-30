# Coding Jerk's dotfiles

Personal dotfiles.

![Zsh features (last exit status, command line, autosuggestions), neovim and tmux](https://i.imgur.com/O1l4gay.png)
*Zsh features (last exit status, command line, autosuggestions), neovim and tmux*

![Lock screen (i3lock)](https://i.imgur.com/X13LdB9.png)
*Lock screen (i3lock)*

![Motd.py and colors](https://i.imgur.com/ejtzI25.png)
*Motd.py and colors*

## Read first

1. This dotfiles created for personal use. Install on your machines at your own risk. Better read them to get inspiration.
1. All files located directly in the repository root due to XDG Base Directory Specification. Where is only single dotfile in home directory: `.zshenv`.

## Structure

1. `config` stands for `$XDG_CONFIG_HOME`
1. `share` stands for `$XDG_DATA_HOME`
1. `bin` contains executables (mainly wrappers and custom scripts) which need to be used as commands
1. `assets` contains wallpaper(s) and color scheme(s)
1. `third-party` contains some useful plugins and tools which should be installed as user
1. `tools` contais scripts which should not be accessable via PATH, such as installation script

## Installation

1. `git clone <repo>`
1. `zsh dotfiles/tools/check-dependencies.zsh all` -- install all listed stuff manually and run check again
1. `zsh dotfiles/tools/install.zsh`
1. `chsh $USER` -- choose zsh as your shell
1. `:PlugInstall`
1. repeat installation steps for root user

## Dependencies

**Dependencies are listed in `tools/check-dependencies.zsh` script that also can automate dependency check**

## Third-party files

- Wallpaper (by Ales Krivec @aleskrivec)
- Plugins
  - Zsh
    - Fast syntax highlighting
    - Autosuggestions
    - Alias tip
  - Vim
    - Vim-plug
