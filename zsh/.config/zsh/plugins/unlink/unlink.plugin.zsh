#!/bin/bash
#
# plugin for enabling `unlink` to handle multiple arguments

function unlink() {
    for arg in "$@"; do
        command unlink "$arg"
    done
}
