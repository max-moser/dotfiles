#!/bin/bash

colour=000000
screenshot=0
image_file=
cursor_opt=
image_opt=
while getopts "c:i:sC" opt; do
	case $opt in
		C)
			cursor_opt="-p default"
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

	[[ -f $image_file ]] && image_opt="-i $image_file"
	i3lock -c $colour $cursor_opt $image_opt

	# if we created a screenshot, delete it again
	[[ -f $screenshot_file ]] && shred -u $screenshot_file
fi

