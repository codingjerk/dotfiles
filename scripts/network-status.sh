#!/bin/sh

current_ip=$(curl \
    --fail \
    --silent \
    --show-error \
    --max-time 10 \
    https://api64.ipify.org \
    2>/dev/null)
curl_status=$?

if [ "$curl_status" -eq 0 ]; then
    case "$current_ip" in
        ''|*[!0-9A-Fa-f:.]*)
            connectivity=offline
            current_ip=
            ;;
        *)
            connectivity=online
            ;;
    esac
else
    connectivity=offline
    current_ip=
fi

state_home=${XDG_STATE_HOME:-"$HOME/.local/state"}
state_dir=$state_home/dotfiles
connectivity_state_file=$state_dir/connectivity
public_ip_state_file=$state_dir/public-ip

umask 077
mkdir -p "$state_dir" || exit 0

previous_connectivity=
if [ -r "$connectivity_state_file" ]; then
    IFS= read -r previous_connectivity < "$connectivity_state_file"
fi

if [ "$connectivity" != "$previous_connectivity" ]; then
    printf '%s\n' "$connectivity" > "$connectivity_state_file" || exit 0

    if [ -n "$previous_connectivity" ]; then
        if [ "$connectivity" = online ]; then
            notify-send \
                -c network \
                -r 9988 \
                "󰤨 Connectivity restored" \
                "Internet access is available"
        else
            notify-send \
                -u critical \
                -c network \
                -r 9988 \
                "󰤭 Connectivity lost" \
                "Internet access is unavailable"
        fi
    fi
fi

[ "$connectivity" = online ] || exit 0

previous_ip=
if [ -r "$public_ip_state_file" ]; then
    IFS= read -r previous_ip < "$public_ip_state_file"
fi

if [ "$current_ip" = "$previous_ip" ]; then
    exit 0
fi

printf '%s\n' "$current_ip" > "$public_ip_state_file" || exit 0
[ -n "$previous_ip" ] || exit 0

notify-send \
    -c network \
    -r 9989 \
    "󰩟 Public IP changed" \
    "$previous_ip → $current_ip"
