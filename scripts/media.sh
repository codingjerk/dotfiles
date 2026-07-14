#!/bin/sh

case "$1" in
    toggle) playerctl play-pause ;;
    play)   playerctl play ;;
    pause)  playerctl pause ;;
    next)   playerctl next ;;
    prev)   playerctl previous ;;
    stop)   playerctl stop
            notify-send -c media -r 9996 "󰓛 Stopped"
            exit 0 ;;
esac

# Give the player a moment to update state/metadata after next/prev
sleep 0.05

status=$(playerctl status 2>/dev/null)

# No player running — say so and bail
if [ -z "$status" ]; then
    notify-send -c media -r 9996 "󰝛 No player"
    exit 0
fi

artist=$(playerctl metadata artist 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)

case "$status" in
    Playing) icon="󰐊" ;;
    Paused)  icon="󰏤" ;;
    *)       icon="󰐎" ;;
esac

if [ -n "$artist" ]; then
    notify-send -c media -r 9996 "$icon $title" "$artist"
else
    notify-send -c media -r 9996 "$icon $title"
fi
