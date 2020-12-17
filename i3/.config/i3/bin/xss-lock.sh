#!/bin/bash

dim_timeout=900
lock_timeout=30
while getopts "d:l:" opt; do
	case $opt in
		d)
			dim_timeout=$OPTARG
			if ! [[ $dim_timeout =~ ^[0-9]+$ ]] ; then
			   echo "error: timeout must be a number" >&2
			   exit 1
			fi
			;;
		l)
			lock_timeout=$OPTARG
			if ! [[ $lock_timeout =~ ^[0-9]+$ ]] ; then
			   echo "error: timeout must be a number" >&2
			   exit 1
			fi
			;;
		*)
			echo "ignoring unknown option: $opt" >&2
			;;
	esac
done

xset s $dim_timeout $lock_timeout
xss-lock --transfer-sleep-lock -n $HOME/.config/i3/bin/dim-screen.sh -- i3lock --nofork

