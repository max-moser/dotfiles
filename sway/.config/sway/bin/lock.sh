#!/bin/bash

colour=000000
screenshot=0
image_file=
blur=0
cursor_opt=
image_opt=
while getopts "c:i:bBsC" opt; do
	case $opt in
		b)
			blur=1
			;;
		B)
			blur=0
			;;
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
			blur=1
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
		# create screenshot
		# TODO: swaylock puts the entire screenshot on each display
		umask 077
		screenshot_file=$(mktemp --suff='.png')
		image_file=$screenshot_file
		grim $screenshot_file
	fi

	if [[ -f $image_file && $blur -gt 0 ]]; then
		# blur the image (the downscaling is done to improve blurring speed)
		umask 077
		temp_file=$(mktemp --suff='.png')
		convert $image_file -resize "12.5%" -blur 0x3 -resize "800%" $temp_file

		# delete the original file if it was a screenshot,
		# but not if it was a specified image file
		[[ -f $screenshot_file ]] && shred -u $screenshot_file
		screenshot_file=$temp_file
		image_file=$temp_file
	fi

	[[ -f $image_file ]] && image_opt="-i $image_file -s fill"
	[[ $screenshot -gt 0 ]] && image_opt="-i $image_file -s tile"
	swaylock -f -c $colour $cursor_opt $image_opt

	# if we created a screenshot, delete it again
	[[ -f $screenshot_file ]] && shred -u $screenshot_file
fi

