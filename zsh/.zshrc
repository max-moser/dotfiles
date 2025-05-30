# add `~/.local/bin` to the path
path+=( "$HOME/.local/bin/" )

# function for checking if a command exists
function cmd_exists() {
    type $1 &> /dev/null
}

# path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# path to the custom folder (for custom themes and plugins)
ZSH_CUSTOM="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# name of the theme to load
ZSH_THEME="max"

# configuration items for the SSH/GPG agent plugins
# (requires `AddKeysToAgent yes` in the ssh config)
zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent lazy yes
zstyle :omz:plugins:ssh-agent lifetime 2h

# make completion not distinguish between "-" and "_"
HYPHEN_INSENSITIVE="true"

# disable command auto-correction
ENABLE_CORRECTION="false"

# display red dots whilst waiting for completion
COMPLETION_WAITING_DOTS="true"

# show timestamps for the commands in `history`
HIST_STAMPS="yyyy-mm-dd"

# set colorization options for `ccat` and `cless`
ZSH_COLORIZE_CHROMA_FORMATTER=terminal256
ZSH_COLORIZE_STYLE="monokai"

# disable auto-setting of $TERM by the `tmux` plugin
ZSH_TMUX_FIXTERM="false"

# hide any warnings regarding configuration from the `pyenv` plugin
ZSH_PYENV_QUIET="true"

# determine where nvm lives
if [[ ! -d $HOME/.nvm  && -f /usr/share/nvm/init-nvm.sh ]]; then
    export NVM_DIR=/usr/share/nvm
fi

# plugins to load (from `$ZSH/plugins/` and `$ZSH_CUSTOM/plugins/`)
plugins=( git emoji urltools )
plugins+=( colorize colored-man-pages )
plugins+=( gpg-agent ssh-agent )
plugins+=( encode64 extract universalarchive )
plugins+=( nvm pyenv )
plugins+=( fno wttr overlaps unlink venv yazi )

# conditionally loaded plugins
cmd_exists fzf && plugins+="fzf"
cmd_exists tmux && plugins+="tmux"

# set smart case in 'less'
export LESS="-Ri ${LESS}"

# now that we're done with reading the plugin config, source omz
source $ZSH/oh-my-zsh.sh

# aliases
alias xopen="xdg-open"
alias xo="xdg-open"
alias pdb="python -m pdb"

if cmd_exists nvim; then
    alias vim="nvim"
    export EDITOR="nvim"
fi

if cmd_exists exa; then
    # the '-b' flag shows binary size prefixes (1024^x)
    # instead of decimal prefixes (as with '-B')
    # the '-g' flag shows the files' groups
    alias ls="exa -g"
    alias lsa="ls -laahbg"
    alias la="ls -lahbg"
    alias l="ls -laahbg"
    alias ll="ls -lhbg"
fi

# disable the beeping
unsetopt beep

bindkey '^j' down-line-or-history
bindkey '^k' up-line-or-history
