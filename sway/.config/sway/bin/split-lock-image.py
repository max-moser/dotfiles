#!/usr/bin/env python3

import json
import os
import subprocess as sp
import sys
from argparse import ArgumentParser
from tempfile import mkstemp

from PIL import Image

parser = ArgumentParser(
    description="split image file into fitting parts for each monitor."
)
parser.add_argument("image", help="the image to split")
args = parser.parse_args()
image_path = args.image

# do a quick check on file permissions
directory = os.path.dirname(image_path) or "."
file_name = os.path.basename(image_path)
can_read_file = os.access(image_path, os.R_OK)
can_write_dir = os.access(directory, os.W_OK)
if not os.path.isfile(image_path) or not can_read_file or not can_write_dir:
    sys.exit(1)

image = Image.open(image_path)

# get information about all active outputs
cp = sp.run(["swaymsg", "-t", "get_outputs"], capture_output=True, text=True)
if cp.returncode != 0:
    sys.exit(2)

outputs = [o for o in json.loads(cp.stdout) if o["active"]]
sorted_outputs = sorted(outputs, key=lambda o: o["rect"]["x"])

# if the image can't be neatly split up into pieces for each output, abort
total_width = sum([int(so["rect"]["width"]) for so in sorted_outputs])
if total_width != image.width:
    sys.exit(3)

# split up the specified image in parts fitting for each output
x = 0
for output in sorted_outputs:
    output_width = int(output["rect"]["width"])
    output_height = int(output["rect"]["height"])

    # crop the image to best fit the monitor
    x_end = x + output_width
    image_part = image.crop((x, 0, x_end, image.height))
    split = image_part.split()
    if len(split) > 3:
        # if there's an alpha channel, try to trim it
        temp = Image.new("RGB", image_part.size, (0, 0, 0))
        temp.paste(image_part, mask=split[3])
        image_part = image_part.crop(temp.getbbox())

    x = x_end
    image_part_name = mkstemp()[1]
    image_part.save(image_part_name, format=image.format)
    print(f"{output['name']}:{image_part_name}")
