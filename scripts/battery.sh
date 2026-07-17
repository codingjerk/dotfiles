#!/bin/sh

for battery in /sys/class/power_supply/BAT*; do
    [ -r "$battery/capacity" ] || continue

    capacity=$(cat "$battery/capacity")
    case "$capacity" in
        ''|*[!0-9]*) continue ;;
    esac

    if [ "$capacity" -lt 10 ]; then
        notify-send \
            -u critical \
            -c battery \
            -r 9992 \
            -h int:value:"$capacity" \
            "󰂃 Battery low" \
            "${capacity}% remaining"
    fi
done
