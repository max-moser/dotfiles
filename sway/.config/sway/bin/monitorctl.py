#!/usr/bin/env python3

import argparse as ap
import json
import subprocess as sp
import sys


def manipulate_list(monitor_index, active_monitors, to_left=False, to_right=False, index=None):
    monitors = active_monitors.copy()
    monitor = monitors.pop(monitor_index)
    if to_left:
        index = max(monitor_index - 1, 0)
    elif to_right:
        index = min(monitor_index + 1, len(monitors))
    elif index is not None:
        index = max(0, min(index, len(monitors)))
    else:
        raise ValueError("one of to_left, to_right and index has to be set")

    monitors.insert(index, monitor)
    return monitors


parser = ap.ArgumentParser()
group = parser.add_mutually_exclusive_group()
group.add_argument("--to-left", "-l", action="store_true", default=False)
group.add_argument("--to-right", "-r", action="store_true", default=False)
group.add_argument("--off", "-o", action="store_true", default=False)
group.add_argument("--on", action="store_true", default=False)
group.add_argument("index", type=int, nargs="?")
args = parser.parse_args()
move = args.to_left or args.to_right or args.index is not None

if move:
    try:
        cp = sp.run(["swaymsg", "-t", "get_outputs"], capture_output=True, text=True, check=True)
        result = json.loads(cp.stdout)

        monitors = sorted(result, key=lambda m: m["rect"]["x"])
        active_monitors = [m for m in monitors if m["active"]]
        inactive_monitors = [m for m in monitors if not m["active"]]
        focused_monitor = [m for m in active_monitors if m["focused"]][0]
        focused_monitor_idx = active_monitors.index(focused_monitor)

        for monitor in active_monitors:
            print(monitor["name"], monitor["model"], monitor["rect"]["x"])

        print("=" * 80)
        x_offset = 0
        for monitor in manipulate_list(focused_monitor_idx, active_monitors, args.to_left, args.to_right, args.index):
            # TODO inactive_monitors do not have .rect.x/y set
            sp.run(["swaymsg", "output", str(monitor["name"]), "position", str(x_offset), str(monitor["rect"]["y"])])
            x_offset += int(monitor["rect"]["width"])
            print(monitor["name"], monitor["model"], monitor["rect"]["x"])

        # TODO warp mouse to focused monitor

    except sp.CalledProcessError as error:
        print(f"error: {error}", file=sys.stderr)

elif args.off:
    try:
        cp = sp.run(["swaymsg", "output", "-", "disable"], check=True)

    except sp.CalledProcessError as error:
        print(f"error: {error}", file=sys.stderr)

elif args.on:
    try:
        cp = sp.run(["swaymsg", "output", "*", "enable"], check=True)

    except sp.CalledProcessError as error:
        print(f"error: {error}", file=sys.stderr)

