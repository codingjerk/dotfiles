#!/usr/bin/env python3

import subprocess
import re
import os


def main():
    monitors = get_active_monitors()
    prefered_monitor = select_prefered_monitor(monitors)

    changes = []
    changes.append(enable_monitor(prefered_monitor))

    for monitor in monitors:
        if monitor != prefered_monitor:
            changes.append(disable_monitor(monitor))

    if any(changes):
        restart_bar()


def get_monitors():
    result = subprocess.run(["xrandr"], check=True, capture_output=True)
    monitor_lines = result.stdout.decode().splitlines()[1:]

    return [
        re.search(r"^([^ ]+) ", line).group(1)
        for line in monitor_lines
        if not line.startswith("  ")
    ]


def get_monitor_status(monitor):
    active_monitors = get_active_monitors()

    if monitor in active_monitors:
        return "on"
    else:
        return "off"


def get_active_monitors():
    result = subprocess.run(["xrandr", "--listactivemonitors"], check=True, capture_output=True)
    monitor_lines = result.stdout.decode().splitlines()[1:]

    return [
        re.search(r": \+([^ ]+) ", line).group(1)
        for line in monitor_lines
    ]


def select_prefered_monitor(monitors):
    prefer_list = os.environ.get("CJ_MONITORS", "").split(";")

    for monitor in prefer_list:
        if monitor in monitors:
            return monitor

    return monitors[0]


def enable_monitor(monitor):
    status = get_monitor_status(monitor)
    if status == "on":
        return 0

    subprocess.run(["xrandr", "--output", monitor, "--auto"], check=True, capture_output=True)
    return 1


def disable_monitor(monitor):
    status = get_monitor_status(monitor)
    if status == "off":
        return 0

    subprocess.run(["xrandr", "--output", monitor, "--off"], check=True, capture_output=True)
    return 1


def restart_bar():
    subprocess.run(["pkill", "polybar"])
    subprocess.Popen(
        ["nohup", "bar"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        preexec_fn=os.setpgrp,
    )


if __name__ == "__main__":
    main()
