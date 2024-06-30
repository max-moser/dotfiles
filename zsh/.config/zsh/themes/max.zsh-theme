# simple prompt, with the first part being colored in green or red respectively, depending on the previous command's exit status
# the prompt char is either # or $, depending on whether the user is root or not
#
# user@host ~ $

# PROMPT='%(?.$fg_bold[green].$fg_bold[red])%n@%m %{$fg_bold[blue]%}%(!.%1~.%~) $(git_prompt_info)%_$(prompt_char)%{$reset_color%} '
PROMPT='%(?.%{$fg_bold[green]%}.%{$fg_bold[red]%})%n@%m %{$fg_bold[blue]%}%(!.%1~.%~) $(git_prompt_info)%(!.#.$)%{$reset_color%} '
RPROMPT='[%*]'

ZSH_THEME_GIT_PROMPT_PREFIX="["
ZSH_THEME_GIT_PROMPT_SUFFIX="] "

