#!/bin/sh

session_id=$(loginctl \
    show-user "$USER" \
    --property=Display \
    --value \
    2>/dev/null)
session_id=${session_id:-${XDG_SESSION_ID:-}}

[ -n "$session_id" ] || exit 0

active=$(loginctl \
    show-session "$session_id" \
    --property=Active \
    --value \
    2>/dev/null)
idle=$(loginctl \
    show-session "$session_id" \
    --property=IdleHint \
    --value \
    2>/dev/null)
locked=$(loginctl \
    show-session "$session_id" \
    --property=LockedHint \
    --value \
    2>/dev/null)

[ "$active" = yes ] || exit 0
[ "$idle" = no ] || exit 0
[ "$locked" != yes ] || exit 0

notify-send \
    -c break \
    -r 9987 \
    "󰒲 Time for a break" \
    "Stand up, move around, and rest your eyes"
