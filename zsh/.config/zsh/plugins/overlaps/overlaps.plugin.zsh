function _execute {
    cmd="$1"
    if [[ -r "$cmd" ]]; then
        cat "$cmd"
    else
        eval "$cmd"
    fi
}

function overlaps {
    if [[ $# -eq 1 ]]; then
        _execute "$1"
    else
        for cmd in $@; do
            _execute "$cmd"
        done | sort | uniq -d
    fi
}
