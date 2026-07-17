#!/bin/sh

zsh_dir=${ZDOTDIR:-"$HOME"}

rm -rf -- "$zsh_dir/.zcompcache" "$zsh_dir"/.zcompdump
