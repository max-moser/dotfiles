function toggle_venv() {
    # deactivate virtualenv if active
    if [[ "${_VENV_ENABLED}" = "1" ]]; then
        deactivate
        unset _VENV_ENABLED
        zle reset-prompt
    else
        if [[ -d ./.venv && -f ./.venv/bin/activate ]]; then
            # "normal" virtualenvs
            source ./.venv/bin/activate
            _VENV_ENABLED=1
            zle reset-prompt

        elif [[ -f ./Pipfile ]]; then
            # pipenv virtualenvs
            source "$(pipenv --venv)/bin/activate"
            _VENV_ENABLED=1
            zle reset-prompt

        else
            notify-send -u critical "No virtualenv found"
        fi
    fi
}

zle -N toggle_venv
bindkey '^v' toggle_venv
