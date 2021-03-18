#!/usr/bin/env python3

import argparse
import json
import os
import re
import subprocess as sp
from dataclasses import dataclass
from typing import List, Set, Union


@dataclass
class Output:
    output: Union[str, None]
    name: Union[str, None]
    mode_x: Union[int, None]
    mode_y: Union[int, None]
    hertz: Union[float, None]
    position_x: int
    position_y: int
    enabled: bool = True
    scale: float = 1
    transform: Union[str, None] = "normal"

    @property
    def identifier(self):
        return self.name or self.output

    @property
    def mode(self):
        if not self.mode_x or not self.mode_y:
            return None

        mode = f"{self.mode_x}x{self.mode_y}"
        refresh = f"{self.hertz:.6f}".rstrip("0").rstrip(".") if self.hertz else None
        if refresh:
            mode += f"@{refresh}Hz"

        return mode

    @property
    def position(self):
        return f"{self.position_x},{self.position_y}"

    def __str__(self):
        string = f'output "{self.identifier}"'
        if self.enabled or self.position_x or self.position_y:
            string += f" position {self.position}"

        if self.mode:
            string += f" mode {self.mode}"

        if self.scale != 1:
            string += f" scale {self.scale}"

        if self.transform and self.transform != "normal":
            string += f" transform {self.transform}"

        if not self.enabled:
            string += " disable"

        return string

    def __hash__(self):
        return hash(self.identifier)

    def __eq__(self, other):
        return self.identifier == other.identifier

    def __ne__(self, other):
        return not (self == other)

    @classmethod
    def from_data(cls, data: dict):
        if not (rect := data.get("rect", None)):
            return None

        output = data["name"]
        name = None
        make, model, serial = data["make"], data["model"], data["serial"]
        if not any((not v or v.lower() == "unknown" for v in (make, model, serial))):
            name = f"{make} {model} {serial}"

        if (mode := data.get("current_mode", None)) is not None:
            mode_x = int(mode["width"])
            mode_y = int(mode["height"])
            hertz = float(mode["refresh"]) / 1000
        else:
            mode_x = None
            mode_y = None
            hertz = None

        position_x = int(rect["x"])
        position_y = int(rect["y"])

        enabled = bool(data["active"])
        scale = float(data.get("scale", 1))
        transform = data.get("transform", "normal")

        return cls(
            output=output,
            name=name,
            mode_x=mode_x,
            mode_y=mode_y,
            hertz=hertz,
            position_x=position_x,
            position_y=position_y,
            enabled=enabled,
            scale=scale,
            transform=transform,
        )

    @classmethod
    def parse(cls, string: str):
        name_pattern = re.compile(r'\boutput\s+(("([^"]+)")|([^\s]+))')
        mode_pattern = re.compile(r"\bmode\s+(\d+)x(\d+)(@(\d*\.?\d+)(Hz)?)?")
        position_pattern = re.compile(r"\bposition\s+(\d+),(\d+)")
        transform_pattern = re.compile(r"\btransform\s+([A-Za-z0-9\-]+)")
        scale_pattern = re.compile(r"\bscale\s+(\d*\.?\d+)")
        status_pattern = re.compile(r"\b(enable|disable)\b")

        _, _, name_a, name_b = name_pattern.findall(string)[0]
        position_results = position_pattern.findall(string)
        mode_results = mode_pattern.findall(string)
        transform_results = transform_pattern.findall(string)
        status_results = status_pattern.findall(string)
        scale_results = scale_pattern.findall(string)

        position_x, position_y = position_results[0] if position_results else (0, 0)
        mode_x, mode_y, _, hertz, _ = mode_results[0] if mode_results else ([None] * 5)
        transform = transform_results[0] if transform_results else "normal"
        status = status_results[0] if status_results else "enabled"
        scale = scale_results[0] if scale_results else 1

        return cls(
            output=None,
            name=name_a or name_b,
            mode_x=int(mode_x) if mode_x is not None else None,
            mode_y=int(mode_y) if mode_y is not None else None,
            hertz=float(hertz) if hertz is not None else None,
            position_x=int(position_x),
            position_y=int(position_y),
            transform=transform,
            scale=scale,
            enabled=(status != "disabled"),
        )


@dataclass
class Profile:
    name: Union[str, None]
    outputs: Set[Output]
    execs: List[str]

    def merge(self, other, force=False):
        workspace_exec_pattern = re.compile(
            r"exec swaymsg workspace .*?, move workspace to '\".*?\"'"
        )

        if not self.execs or force:
            self.execs = other.execs
        elif other.execs:
            # if the profile already defined execs and the force flag isn't set,
            # we still want to replace the old workspace execs with the new execs
            non_workspace_execs = [
                e for e in self.execs if not workspace_exec_pattern.match(e)
            ]
            self.execs = other.execs + non_workspace_execs

        self.outputs = other.outputs
        self.name = other.name or self.name

    def __str__(self):
        profile_header = f"profile {self.name}" if self.name else "profile"
        ordered_outputs = sorted(self.outputs, key=lambda o: o.position_x)
        formatted_outputs = "\n".join((f"\t{output}" for output in ordered_outputs))
        formatted_execs = "\n".join((f"\t{exec}" for exec in self.execs))
        body = f"{formatted_outputs}\n{formatted_execs}".rstrip()
        return f"{profile_header} {{\n{body}\n}}"

    def __eq__(self, other):
        return self.outputs == other.outputs

    def __ne__(self, other):
        return not (self == other)


parser = argparse.ArgumentParser(
    description=(
        "small utility for parsing 'swaymsg -t get_outputs' and merging the current "
        "monitor profile into the kanshi config"
    )
)
parser.add_argument(
    "-c",
    "--config",
    help="kanshi configuration file",
    default="~/.config/kanshi/config",
)
parser.add_argument(
    "-D",
    "--dry-run",
    help="print resulting kanshi config instead of writing it to disk",
    default=False,
    action="store_true",
)
parser.add_argument(
    "-w",
    "--workspaces",
    help="save exec directives for assigning workspaces to monitors",
    default=False,
    action="store_true",
)
parser.add_argument(
    "-o",
    "--override-execs",
    help="override the exec commands of the merged profile",
    default=False,
    action="store_true",
)
parser.add_argument(
    "-n",
    "--profile-name",
    help="name of the profile to set",
    default=None
)
args = parser.parse_args()
kanshi_config = os.path.expanduser(args.config)

# if the kanshi config exists, parse it - otherwise, create an empty list of profiles
if os.path.isfile(kanshi_config):
    profiles = []
    profile_pattern = re.compile(r"profile([^{]+)\{([^}]+)\}")
    with open(kanshi_config, "r") as kanshi_config_file:
        profile_str = ""
        for line in kanshi_config_file:
            profile_str += line
            if match := profile_pattern.findall(profile_str):
                name, body = match[0]
                outputs = []
                execs = []
                for line in body.splitlines():
                    line = line.strip()
                    if line.startswith("output"):
                        outputs.append(Output.parse(line))
                    elif line.startswith("exec"):
                        execs.append(line)

                profile = Profile(name=name.strip(), outputs=set(outputs), execs=execs)
                profiles.append(profile)
                profile_str = ""

else:
    profiles = []
    if path := os.path.dirname(kanshi_config):
        os.makedirs(path, exist_ok=True)

# parse the current profile from "swaymsg -t get_outputs"
cp = sp.run(["swaymsg", "-t", "get_outputs"], capture_output=True, text=True)
outputs = json.loads(cp.stdout)
parsed_outputs = {
    output for output in (Output.from_data(o) for o in outputs) if output is not None
}
profile = Profile(name=args.profile_name, outputs=set(parsed_outputs), execs=[])

# if the workspaces are to be saved, we parse it from "swaymsg -t get_workspaces"
if args.workspaces:
    cp = sp.run(["swaymsg", "-t", "get_workspaces"], capture_output=True, text=True)
    workspaces = json.loads(cp.stdout)

    for workspace in sorted(workspaces, key=lambda w: w["name"]):
        outputs = [o for o in parsed_outputs if o.output == workspace["output"]]
        if outputs:
            cmd = (
                f"exec swaymsg workspace {workspace['name']}, "
                f"move workspace to '\"{outputs[0].identifier}\"'"
            )

            profile.execs.append(cmd)

# merge the current profile into the existing profiles
if profile in profiles:
    p = profiles[profiles.index(profile)]
    p.merge(profile, force=args.override_execs)
else:
    profiles.append(profile)

# format and write the result
result = "\n\n".join((str(p).strip() for p in profiles))

if args.dry_run:
    print(result)
else:
    with open(kanshi_config, "w") as kanshi_config_file:
        print(result, file=kanshi_config_file)
