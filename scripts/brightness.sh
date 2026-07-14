#!/bin/sh
case "$1" in
    up)   brightnessctl -q set +5% ;;
    down) brightnessctl -q set 5%- ;;
esac

bright=$(brightnessctl -m | awk -F, '{print int($4)}')

notify-send -c brightness -r 9994 -h int:value:"$bright" "󰃟 ${bright}%"
