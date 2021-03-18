#!/usr/bin/env python3

import argparse
import json
import os
import re
import subprocess as sp
import uuid
from dataclasses import dataclass
from typing import List, Set


@dataclass
class Output:
    output: str
    name: str
    mode_x: int
    mode_y: int
    hertz: float
    position_x: int
    position_y: int

    @property
    def identifier(self):
        return self.name or self.output

    @property
    def mode(self):
        mode = f"{self.mode_x}x{self.mode_y}"
        refresh = f"{self.hertz:.2f}".rstrip("0").rstrip(".") if self.hertz else None
        if refresh:
            mode += "@{refresh}Hz"

        return mode

    @property
    def position(self):
        return f"{self.position_x},{self.position_y}"

    def __str__(self):
        return f'output "{self.identifier}" mode {self.mode} position {self.position}'

    def __hash__(self):
        return hash(self.identifier)

    def __eq__(self, other):
        return self.identifier == other.identifier

    def __ne__(self, other):
        return not (self == other)

    @classmethod
    def from_data(cls, data: dict):
        # TODO output directives: (enabled|disabled), (scale), (transform)
        # TODO right now, connected but (actively) disabled monitors aren't counted
        #      - but they should be!
        #      -> NOTE: only connected monitors are listed by "swaymsg -t get_outputs"!
        if not data.get("active", False):
            return None
        elif not (mode := data.get("current_mode", None)):
            return None
        elif not (rect := data.get("rect", None)):
            return None

        output = data["name"]
        name = None
        make, model, serial = data["make"], data["model"], data["serial"]
        if not any((not v or v.lower() == "unknown" for v in (make, model, serial))):
            name = f"{make} {model} {serial}"

        mode_x = int(mode["width"])
        mode_y = int(mode["height"])
        hertz = float(mode["refresh"]) / 1000

        position_x = int(rect["x"])
        position_y = int(rect["y"])

        return cls(
            output=output,
            name=name,
            mode_x=mode_x,
            mode_y=mode_y,
            hertz=hertz,
            position_x=position_x,
            position_y=position_y,
        )

    @classmethod
    def parse(cls, string: str):
        # TODO output directives: (enabled|disabled), (scale), (transform)
        name_pattern = re.compile(r'output\s+(("([^"]+)")|([^\s]+))')
        mode_pattern = re.compile(r"mode\s+(\d+)x(\d+)(@(\d*\.?\d+)(Hz)?)?")
        position_pattern = re.compile(r"position\s+(\d+),(\d+)")

        _, _, name_a, name_b = name_pattern.findall(string)[0]
        mode_x, mode_y, _, hertz, _ = mode_pattern.findall(string)[0]
        position_x, position_y = position_pattern.findall(string)[0]

        return cls(
            output=None,
            name=name_a or name_b,
            mode_x=int(mode_x),
            mode_y=int(mode_y),
            hertz=float(hertz),
            position_x=int(position_x),
            position_y=int(position_y),
        )


@dataclass
class Profile:
    name: str
    outputs: Set[Output]
    execs: List[str]

    def merge(self, other):
        self.outputs = other.outputs
        if not self.execs:
            self.execs = other.execs

    def __str__(self):
        # TODO 'exec swaymsg workspace [X], move workspace to '"[DISPLAY NAME]"'
        #      note: both types of quotes are important around the display name!
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


parser = argparse.ArgumentParser()
parser.add_argument(
    "-c",
    "--config",
    help="kanshi configuration file",
    default="~/.config/kanshi/config",
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
    path = os.path.dirname(kanshi_config)
    os.path.makedirs(path)
    profiles = []

# parse the current profile from "swaymsg -t get_outputs"
cp = sp.run(["swaymsg", "-t", "get_outputs"], capture_output=True, text=True)
outputs = json.loads(cp.stdout)
parsed_outputs = {
    output for output in (Output.from_data(o) for o in outputs) if output is not None
}
profile = Profile(name=None, outputs=set(parsed_outputs), execs=[])

# merge the current profile into the existing profiles
if profile in profiles:
    p = profiles[profiles.index(profile)]
    p.merge(profile)
else:
    profiles.append(profile)

# format and write the result
result = "\n\n".join((str(p).strip() for p in profiles))

with open(kanshi_config, "w") as kanshi_config_file:
    print(result, file=kanshi_config_file)
