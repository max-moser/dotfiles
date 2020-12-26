#!/bin/bash

no_lock_file="$HOME/.no-lock"
mode=1
toggle=0
screen_saver_time=900
screen_off_time=1800
while getopts "edtO:S:" opt; do
	case $opt in
		e)
			mode=1
			;;
		d)
			mode=0
			;;
		t)
			toggle=1
			;;
		O)
			screen_off_time=$OPTARG
			if ! [[ $screen_off_time =~ ^[0-9]+$ ]] ; then
			   echo "error: screen off time must be a number" >&2
			   exit 1
			fi
			;;
		S)
			screen_saver_time=$OPTARG
			if ! [[ $screen_saver_time =~ ^[0-9]+$ ]] ; then
			   echo "error: screen saver time must be a number" >&2
			   exit 1
			fi
			;;
		*)
			echo "ignoring unknown option: $opt" >&2
			;;
	esac
done

if [[ $toggle -gt 0 ]]; then
	if [[ ! -f $no_lock_file ]]; then
		mode=0
	else
		mode=1
	fi
fi

if [[ $mode -gt 0 ]]; then
	# enable screen saver
	xset s $screen_saver_time $screen_saver_time
	xset dpms $screen_saver_time $screen_saver_time $screen_off_time
	xset +dpms
	rm -f $no_lock_file
else
	# disable screen saver
	xset s 0 0
	xset dpms 0 0 0
	xset -dpms
	touch $no_lock_file
fi

