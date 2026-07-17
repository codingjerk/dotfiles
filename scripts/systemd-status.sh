#!/bin/sh

system_units=$(systemctl \
    --failed \
    --no-legend \
    --plain \
    --no-pager \
    --full \
    2>/dev/null)
system_units_status=$?

user_units=$(systemctl \
    --user \
    --failed \
    --no-legend \
    --plain \
    --no-pager \
    --full \
    2>/dev/null)
user_units_status=$?

[ "$system_units_status" -eq 0 ] || exit 0
[ "$user_units_status" -eq 0 ] || exit 0

failed_units=$(
    {
        printf '%s\n' "$system_units" |
            awk 'NF { print "system: " $1 }'
        printf '%s\n' "$user_units" |
            awk 'NF { print "user: " $1 }'
    }
)

state_home=${XDG_STATE_HOME:-"$HOME/.local/state"}
state_dir=$state_home/dotfiles
state_file=$state_dir/failed-systemd-units

umask 077
mkdir -p "$state_dir" || exit 0

previous_failed_units=
state_exists=no
if [ -r "$state_file" ]; then
    previous_failed_units=$(cat "$state_file")
    state_exists=yes
fi

if [ "$failed_units" = "$previous_failed_units" ] &&
    [ "$state_exists" = yes ]; then
    exit 0
fi

printf '%s\n' "$failed_units" > "$state_file" || exit 0

if [ -n "$failed_units" ]; then
    notify-send \
        -u critical \
        -c systemd \
        -r 9990 \
        "󰀦 Systemd units failed" \
        "$failed_units"
elif [ -n "$previous_failed_units" ]; then
    notify-send \
        -c systemd \
        -r 9990 \
        "󰄬 Systemd units recovered" \
        "No failed system or user units remain"
fi
