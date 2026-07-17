#!/bin/sh

mount_point=/home/$UID
used=$(df -P "$mount_point" 2>/dev/null | awk 'NR == 2 {
    sub(/%$/, "", $5)
    print $5
}')

case "$used" in
    ''|*[!0-9]*) exit 0 ;;
esac

remaining=$((100 - used))

if [ "$remaining" -lt 10 ]; then
    notify-send \
        -u critical \
        -c disk \
        -r 9991 \
        -h int:value:"$remaining" \
        "󰋊 Disk space low" \
        "${remaining}% remaining on ${mount_point}"
fi
