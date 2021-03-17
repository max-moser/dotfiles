#!/bin/bash

# roughly vienna
DEFAULT_LOCATION="47:15"

location=
temperature=
geoclue_exec="/usr/lib/geoclue-2.0/demos/agent"
while getopts "l:t:g:" opt; do
	case $opt in
		l)
			location=$OPTARG
			if ! [[ $location =~ ^[0-9]{1,3}(\.[0-9]+)?*:[0-9]{1,3}(\.[0-9]+)?$ ]] ; then
			   echo "error: location must be of form LAT:LON, e.g. 47:15" >&2
			   exit 1
			fi
			;;
		t)
			temperature=$OPTARG
			if ! [[ $temperature =~ ^[0-9]{1,4}[kK]?:[0-9]{1,4}[kK]?$ ]] ; then
			   echo "error: temperature must be of form DAY:NIGHT, e.g. 6500K:4500K" >&2
			   exit 1
			fi
			;;
		g)
			geoclue_exec=$OPTARG
			;;
		*)
			echo "ignoring unknown option: $opt" >&2
			;;
	esac
done


location_flag=
if [[ -z $location ]]; then
	if ! type ${geoclue_exec} > /dev/null; then
		location_flag="-l ${DEFAULT_LOCATION}"
	else
		${geoclue_exec} &>/dev/null &
		sleep 1
	fi
else
	location_flag="-l ${location}"
fi

temperature_flag=
if [[ ! -z $temperature ]]; then
	temperature_flag="-t ${temperature}"
fi

gammastep ${location_flag} ${temperature_flag}

