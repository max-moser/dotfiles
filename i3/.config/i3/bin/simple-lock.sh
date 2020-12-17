#!/bin/bash

timeout=60
colour=000000
while getopts "t:c:" opt; do
	case $opt in
		t)
			timeout=$OPTARG
			if ! [[ $timeout =~ ^[0-9]+$ ]] ; then
			   echo "error: timeout must be a number" >&2
			   exit 1
			fi
			;;
		c)
			colour=$OPTARG
			if ! [[ $colour =~ ^[0-9a-f]{6}$ ]] ; then
			   echo "error: colour must be a 6-digit hexadecimal number" >&2
			   exit 1
			fi
			;;
		*)
			echo "ignoring unknown option: $opt" >&2
			;;
	esac
done

if [[ ! -f $HOME/.no-lock ]]; then
	i3lock -p default -c $colour
	locked=1
	while [[ $locked -gt 0 ]]; do
		sleep $timeout
		pgrep i3lock
		if [[ $? -eq 0 ]]; then
			xset dpms force off
			sleep 1
		else
			locked=0
		fi
	done
fi

