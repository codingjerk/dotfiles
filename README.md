# dotfiles

A well-documented, well-structured dotfiles.

## Installation

1. `git clone --recursive-submodules`
1. `zsh dotfiles/tools/check-dependencies.zsh`
1. `zsh dotfiles/tools/install.zsh`
1. (optional) enable user services for server (dotfiles/services)
1. (optional) repeat installation steps for root user

## Dependencies

**Dependencies listed in `tools/check-dependencies.zsh` script that also can automate dependency check**

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
  - npm
    - npm-init.js
      - editorconfig
      - package name
      - package description
      - MIT license
      - author (from git)
      - .gitignore
  - vim
    - vim-plug as third-party
  - third-parties
    - Remove gone, i3lock, vim-plug, st
  - Place [name].in and [file] files
- X11
  - Replace dmenu ?
  - Font config
  - XCompose
    - Greek
    - Japanese
      - Prefixes: j from hiragana, J for katakana
      - Suffixes: remove
    - Math
    - Emoji
  - Custom GTK theme
  - Include gtk, cursor and icons as third-party
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
