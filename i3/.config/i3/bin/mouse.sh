#!/bin/bash

disable_acceleration=1
speed_factor=0.33
while getopts "f:" opt; do
	case $opt in
		f)
			speed_factor=$OPTARG
			if ! [[ $speed_factor =~ ^[+-]?[0-9]+\.?[0-9]*$ ]] ; then
			   echo "error: speed factor must be a floating-point number between -1 and +1" >&2
			   exit 1
			fi
			;;
		*)
			echo "ignoring unknown option: $opt" >&2
			;;
	esac
done

for id in $(xinput list | grep "pointer" | cut -d "=" -f 2 | cut -f 1); do
	if [[ $disable_acceleration -gt 0 ]]; then
		xinput --set-prop $id "libinput Accel Profile Enabled" 0, 1
	fi

	xinput --set-prop $id "libinput Accel Speed" $speed_factor
done

