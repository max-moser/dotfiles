#!/bin/bash

timeout=60
colour=000000
screenshot=0
image_file=
while getopts "t:c:i:s" opt; do
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
		s)
			screenshot=1
			;;
		i)
			image_file=$OPTARG
			if [[ ! -f $image_file ]]; then
				echo "error: image file $image_file does not exist" >&2
				exit 1
			fi
			;;
		*)
			echo "ignoring unknown option: $opt" >&2
			;;
	esac
done

if [[ ! -f $HOME/.no-lock ]]; then
	screenshot_file=
	if [[ $screenshot -gt 0 ]]; then
		# create screenshot and blur it
		# (the downscaling is done to improve blurring speed)
		umask 077
		screenshot_file=$(mktemp --suff='.png')
		image_file=$screenshot_file
		scrot -z -o $screenshot_file
		convert $screenshot_file -resize "12.5%" $screenshot_file
		convert $screenshot_file -blur 0x3 $screenshot_file
		convert $screenshot_file -resize "800%" $screenshot_file
	fi

	if [[ -f $image_file ]]; then
		i3lock -p default -c $colour -i $image_file
	else
		i3lock -p default -c $colour
	fi

	# if we created a screenshot, delete it again
	[[ -f $screenshot_file ]] && shred -u $screenshot_file

	if [[ $timeout -gt 0 ]]; then
		locked=1
		while [[ $locked -gt 0 ]]; do
			sleep ${timeout}s
			pgrep i3lock
			if [[ $? -eq 0 ]]; then
				xset dpms force off
				sleep 1
			else
				locked=0
			fi
		done
	fi
fi

