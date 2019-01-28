# dotfiles

A well-documented, well-structured dotfiles.

## Installation

1. `git clone --recursive-submodules`
1. `sh dotfiles/tools/check-dependencies.sh`
1. `sh dotfiles/tools/install.sh`
1. (optional) enable user services for server (dotfiles/services)
1. (optional) repeat installation steps for root user

## Dependencies

- zsh
- nvim
- python (3.x)
  - psutil
- fzf
- fd

### Optional / Recomendations

- less
- tmux
- htop
- ssh
- gpg2
- exa
- hexyl
- xtools (void linux only, for command-not-found feature)
- pkgfile (arch linux only, for command-not-found feature)

### Services

- transmission (daemon)
- mpd
- minidlna

### GUI dependencies

- Fonts
  - Fira Mono
  - Font Awesome (4.x)
  - Noto Fonts
- Themes
  - Adapta (GTK + QT Theme)
  - Breeze (icons)
  - Breeze Snow (Cursor)
- X11
- feh
- polybar
- i3wm
- maim
- slop
- imagemagic
- zathura
- KeeWeb
- chromium
- mpv

## Included third-party stuff

- Wallpapers
- Plugins
  - Zsh
    - Fast syntax highlighting
    - Autosuggestions
    - Alias tip
- Gone (pomodoro timer)
- st
- dmenu
- i3lock-color (as a linux x86_64 binary)
- vim-plug

## TODOz

- CLI
  - Youtube-dl
    - Config
  - Transmission
    - Remote cli aliases (for magnets, list and other)
- X11
  - Font config
- System
  - Custom minimal kernel config (with per-machine corrections)
    - Disable IPv6
    - Disable watchdogs
    - System linux colors (in/before init stage) (kernel patch?)
  - Sysctl
  - Resolv.conf
  - Pulseaudio
    - Move config to user-space (including daemon config)
    - Networking
- Other
  - OpenBSD
- Problems (without easy solution)
  - Environment problem
    - SSH (xauthority, `authorized_keys`)
    - runit user services
  - Use `XDG_DATA_DIRS/icons` to store icons (cursor default theme index file)
  - Vim, st, dmenu and gone hard-included
  - Installation script is bad
- Fixes (easy solution)
  - /services/runit → /config/runit
  - Rename environment variables
    - `DOTFILES_DIR -> CJ_DOTFILES_DIR / CJ_DOTFILES / CJ_DOTS`
    - `X_AUTOSTART -> CJ_X_AUTOSTART`
    - `FONT → CJ_X_MONOFONT`
