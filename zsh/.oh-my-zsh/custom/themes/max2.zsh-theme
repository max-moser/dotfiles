# ZSH Theme - based on the 'bira' theme from OMZ
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

# define some colors
local blue='%{$fg_bold[blue]%}'
local red='%{$fg_bold[red]%}'
local reset='%{$reset_color%}'

# define what the username@host line will look like
local user_host='%(?.%{$fg_bold[green]%}.%{$fg_bold[red]%})%n@%m %{$reset_color%}'
if [[ $UID -eq 0 ]]; then
    local user_symbol="${red}\#${reset}"
else
    local user_symbol="${blue}\$${reset}"
fi

local current_dir='%{$fg_bold[blue]%}%~ %{$reset_color%}'
local git_branch='$(git_prompt_info)'
local rvm_ruby='$(ruby_prompt_info)'
local venv_prompt='$(virtualenv_prompt_info)'

ZSH_THEME_RVM_PROMPT_OPTIONS="i v g"

# prompts
# ╭
# ╰
PROMPT="${user_host}${current_dir}${rvm_ruby}${git_branch}${venv_prompt}
%B${user_symbol}%b "
RPROMPT="%B${return_code}%b [%*]"

# git prompt
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

# ruby prompt
ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg[red]%}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="› %{$reset_color%}"

# venv prompt
ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX="%{$fg[green]%}‹"
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="› %{$reset_color%}"
ZSH_THEME_VIRTUALENV_PREFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX
ZSH_THEME_VIRTUALENV_SUFFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX

