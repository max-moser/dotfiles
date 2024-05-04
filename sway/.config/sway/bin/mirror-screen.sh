#!/bin/bash
# asks for a screen to mirror via slurp, and then starts wl-mirror
# inspired by wl-present

die() {
    notify-send "$1"
    exit 1
}

ask-output() {
    slurp -b "#00000000" -B "#00000000" -c "#009900" -w 4 -f "%o" -or 2>/dev/null || die "Screen mirroring aborted"
}

wl-mirror -S "$(ask-output)"
