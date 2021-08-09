#!/usr/bin/env python3

import argparse as ap
import json
import subprocess as sp
import sys

parser = ap.ArgumentParser()
parser.add_argument("workspace_name", type=str)
parser.add_argument("--activate", "-a", action="store_true", default=False)
args = parser.parse_args()


# get a list of workspaces
cp = sp.run(
    ["swaymsg", "-t", "get_workspaces"], capture_output=True, text=True, check=True
)
workspaces = json.loads(cp.stdout)

# find the matching workspace
matching_workspaces = [w for w in workspaces if w["name"] == args.workspace_name]
if not matching_workspaces:
    print("error: could not find a matching workspace!", file=sys.stderr)
    sys.exit(1)
elif len(matching_workspaces) > 1:
    print("error: ambiguous workspace reference!", file=sys.stderr)
    sys.exit(2)
else:
    workspace = matching_workspaces[0]

# calculate the center of the workspace
rect = workspace["rect"]
x_pos = rect["x"] + (rect["width"] / 2)
y_pos = rect["y"] + (rect["height"] / 2)

# position the mouse in the middle of the screen, and optionally focus the workspace
try:
    command = ["swaymsg", "seat", "-", "cursor", "set", str(x_pos), str(y_pos)]
    if args.activate:
        command += [",", "workspace", "--", "--no-auto-back-and-forth", args.workspace_name]

    cp = sp.run(command, check=True)

except sp.CalledProcessError as error:
    print(f"error: {error}", file=sys.stderr)
