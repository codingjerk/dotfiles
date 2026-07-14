#!/bin/sh

case "$1" in
    up)      wpctl set-volume -l 2.0 @DEFAULT_SINK@ 5%+ ;;
    down)    wpctl set-volume @DEFAULT_SINK@ 5%- ;;
    mute)    wpctl set-mute @DEFAULT_SINK@ toggle ;;
    micmute) wpctl set-mute @DEFAULT_SOURCE@ toggle
             case "$(wpctl get-volume @DEFAULT_SOURCE@)" in
                 *MUTED*) notify-send -c mic -r 9995 "󰍭 Mic muted" ;;
                 *)       notify-send -c mic -r 9995 "󰍬 Mic on" ;;
             esac
             exit 0 ;;
esac

out=$(wpctl get-volume @DEFAULT_SINK@)
vol=$(echo "$out" | awk '{print int($2*100)}')

case "$out" in
    *MUTED*) notify-send -c volume -r 9993 -h int:value:0 "󰝟 Muted" ;;
    *)       notify-send -c volume -r 9993 -h int:value:$vol "󰕾 ${vol}%" ;;
esac
