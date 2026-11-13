# add `~/.local/bin` to the path
path+=( "$HOME/.local/bin" )

# function for checking if a command exists
function cmd_exists() {
    [[ ${+commands[$1]} -eq 1 ]]
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

# determine where nvm lives
if [[ ! -d $HOME/.nvm  && -f /usr/share/nvm/init-nvm.sh ]]; then
    export NVM_DIR=/usr/share/nvm
fi

# plugins to load (from `$ZSH/plugins/` and `$ZSH_CUSTOM/plugins/`)
plugins=( git emoji urltools )
plugins+=( colorize colored-man-pages )
plugins+=( gpg-agent ssh-agent )
plugins+=( encode64 extract universalarchive )
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

# foot(1) integration:
# emit "OSC-133;A" before each command, to enable jumping between prompts in foot
# similarly, emit "OSC-133;C" and "OSC-133;D" around output of commands to enable its piping in foot
function precmd {
    print -Pn "\e]133;A\e\\"
    if ! builtin zle; then
        print -n "\e]133;D\e\\"
    fi
}

function preexec {
    print -n "\e]133;C\e\\"
}

# accept job number with or without leading % for `fg`, `bg`, and `disown`
function fg () {
    builtin fg "%${1#%}"
}

function bg () {
    builtin bg "%${1#%}"
}

function disown () {
    builtin disown "%${1#%}"
}

# completion: (1) try to simply complete the word (2) run the matchers below (3) complete approximately, allowing for some errors
zstyle ':completion:*' completer _complete _match _approximate
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX + $#SUFFIX) / 3 > 7 ? 7 : ($#PREFIX + $#SUFFIX) / 3))numeric)'

# case-insensitive completion
# (1) case-insensitive (2) search to the right (3) search to the left and to the right
# note: making dashes and underscores interchangeable in 'm:*' causes some extra dashes being introduced sometimes
zstyle ':completion:*' matcher-list 'm:{[:upper:][:lower:]}={[:lower:][:upper:]}' '+r:|=*' '+l:|=* r:|=*'
