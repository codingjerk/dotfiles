#!/usr/bin/env python3

import subprocess
import re
import os


def main():
    monitors = get_monitors()
    print(f"Active monitors: {monitors}")
    prefered_monitor = select_prefered_monitor(monitors)
    print(f"Prefered monitor: {prefered_monitor}")

    changes = []
    changes.append(enable_monitor(prefered_monitor))

    for monitor in monitors:
        if monitor != prefered_monitor:
            changes.append(disable_monitor(monitor))

    if any(changes) or not is_bar_running():
        restart_bar()


def get_monitors():
    result = subprocess.run(["xrandr"], check=True, capture_output=True)
    monitor_lines = result.stdout.decode().splitlines()[1:]

    return [
        re.search(r"^([^ ]+) ", line).group(1)
        for line in monitor_lines
        if not line.startswith("  ") and " connected" in line
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
        re.search(r": \+?\*?([^ ]+) ", line).group(1)
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

    subprocess.run(["xrandr", "--output", monitor, "--auto"], check=True)
    return 1


def disable_monitor(monitor):
    status = get_monitor_status(monitor)
    if status == "off":
        return 0

    subprocess.run(["xrandr", "--output", monitor, "--off"], check=True)
    return 1


def is_bar_running():
    result = subprocess.run(["ps", "x"], capture_output=True)
    processes = result.stdout.decode().splitlines()

    for process in processes:
        columns = [c for c in process.split(" ") if c != ""]
        process = columns[4:]

        if process == ["eww"]:
            return True

    return False


def restart_bar():
    subprocess.run(["pkill", "eww"])
    subprocess.Popen(
        ["nohup", "vertical_bar"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        preexec_fn=os.setpgrp,
    )


if __name__ == "__main__":
    main()
