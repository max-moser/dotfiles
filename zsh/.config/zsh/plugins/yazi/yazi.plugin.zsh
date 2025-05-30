# yazi wrapper script for moving to the current directory on yazi exit
# based on: https://yazi-rs.github.io/docs/quick-start/#shell-wrapper
function yazi() {
    local tmp cwd
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    command yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd" || true
    fi
    rm -f -- "$tmp"
}
