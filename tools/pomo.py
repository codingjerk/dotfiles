#!/usr/bin/env python3

from datetime import timedelta
import itertools
import time

def pomodoro_cycle(focus_duration, break_duration, long_break_duration, long_break_cycle):
    for cycle in itertools.count(start=1):
        pomodoro_focus(focus_duration)
        pomodoro_break(cycle, break_duration, long_break_duration, long_break_cycle)

def pomodoro_focus(duration):
    notify_focus(duration)
    time.sleep(duration.total_seconds())

def pomodoro_break(iteration, short_duration, long_duration, long_cycle):
    if iteration % long_cycle == 0:
        break_type, duration = "long", long_duration
    else:
        break_type, duration = "short", short_duration

    notify_break(break_type, duration)
    time.sleep(duration.total_seconds())

def notify_focus(duration):
    notify(f"Focus for {int(duration.total_seconds() / 60)} minutes")

def notify_break(type, duration):
    notify(f"Take a {type} break for {int(duration.total_seconds() / 60)} minutes")

def notify(message):
    print(message)
    print('\a')
    input("Accept? Press Return to continue...")

if __name__ == "__main__":
    focus_duration = timedelta(seconds=25)
    break_duration = timedelta(seconds=5)
    long_break_duration = timedelta(seconds=15)
    long_break_cycle = 4

    pomodoro_cycle(focus_duration, break_duration, long_break_duration, long_break_cycle)
