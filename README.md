# Dotfiles

> Configuration of software I personally use for software development

## Install

Add user:

```sh
useradd -m -G docker,systemd-journal,users,wheel -k /dev/null -s /usr/bin/zsh cj
```

Run installation script:

```sh
curl https://dots.cj.dog | sh
```

**WARNING:** it's for me and myself only,
I don't recommend to run it on your own machines.

If you're not me (lol), just clone this repository and
poke into configuration files (it's in `config` directory!).

### Extra steps (on new hosts)

1. Generate ssh keys:

```sh
ssh-keygen -t ed25519
```

2. Import gpg keys:

```sh
gpg --import <key>.gpg
gpg --edit-key <key-id>
# trust, 5, save
```

3. Initialize password store:

```sh
git clone <repo> .password-store
```

4. Install LSPs for `helix`.
   Check `helix`'s `language.toml` for actual sources
   and build instructions.

## Update

Update tool it will do everything (except installation):

```sh
~/dotfiles/tools/update
```

## How it works?

This repository contains:

- `config` -- a bunch of configuration files and templates. Main directory here
- `settings` -- configurable settings (color palette, font, etc.), used by templates
- `wallpaper.png`
- `install` -- tool to clone this repo and run update
- `update` -- tool to render templates into configuration files

Itself, repository should be placed somewhere in your home directory,
and after running `update` it will place rendered configuration files
into your home directory.
