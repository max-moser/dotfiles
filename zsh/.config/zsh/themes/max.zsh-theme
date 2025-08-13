# simple prompt, with the first part being colored in green or red respectively, depending on the previous command's exit status
# the prompt char is either # or $, depending on whether the user is root or not
#
# user@host ~ $
#
# available "simple prompt escapes" are listed in `man 1 zshmisc`
# they can be tested with the builtin `print -P ...`
PROMPT='%B%(?.%F{green}.%F{red})%n@%m %F{blue}%(!.%1~.%~) $(git_prompt_info)%(!.#.$)%f%b '
RPROMPT='[%*]'

ZSH_THEME_GIT_PROMPT_PREFIX="["
ZSH_THEME_GIT_PROMPT_SUFFIX="] "

