#!/bin/zsh
# If you source this file, it will set WTTR_PARAMS as well as show weather.

# WTTR_PARAMS is space-separated URL parameters, many of which are single characters that can be
# lumped together. For example, "F q m" behaves the same as "Fqm".
if [[ -z "${WTTR_PARAMS}" ]]; then
  # Form localized URL parameters for curl
  WTTR_PARAMS+='F'
  if [[ -t 1 ]] && [[ "$(tput cols)" -lt 125 ]]; then
      WTTR_PARAMS+='n'
  fi 2> /dev/null
  for _token in $( locale LC_MEASUREMENT ); do
    case ${_token} in
      1) WTTR_PARAMS+='m' ;;
      2) WTTR_PARAMS+='u' ;;
    esac
  done 2> /dev/null
  unset _token
  export WTTR_PARAMS
fi

forecast() {
  local url="wttr.in"
  local location=${WTTR_DEFAULT_LOCATION}

  if [[ $# -ge 1 ]]; then
    location="${1// /+}"
    shift
  fi

  if [[ ! -z ${location} ]]; then
    url="wttr.in/${location}"
  fi

  local args=""
  for p in ${WTTR_PARAMS} "$@"; do
    args+=" --data-urlencode ${p} "
  done

  curl -fGsS -H "Accept-Language: ${LANG%_*}" ${=args} --compressed "${url}"
}
