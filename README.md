# dotfiles

A well-documented, well-structured dotfiles.

## Installation

1. `git clone`
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
  - Vim
    - Vim-plug

## TODOz

- CLI
  - Place [name].in and [file] files
- X11
  - XCompose
    - Greek
    - Japanese
      - Prefixes: j from hiragana, J for katakana
      - Suffixes: remove
    - Math
    - Emoji
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
  - Use `XDG_DATA_DIRS/icons` to store icons (cursor default theme index file)
- Fixes (easy solution)
  - /services/runit → /config/runit
