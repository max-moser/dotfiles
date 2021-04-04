#!/bin/bash

colour=000000
screenshot=0
image_file=
blur=0
cursor_opt=
image_opt=
split_lock_image_script=$HOME/.config/sway/bin/split-lock-image.py
while getopts "c:i:bBsS:C" opt; do
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
			if ! [[ $colour =~ ^[0-9a-f]{6}$ ]]; then
			   echo "error: colour must be a 6-digit hexadecimal number" >&2
			   exit 1
			fi
			;;
		s)
			screenshot=1
			blur=1
			;;
		S)
			split_lock_image_script=$OPTARG
			if ! [[ ! -f $split_lock_image_script ]]; then
			   echo "error: cannot find script $split_lock_image_script" >&2
			   exit 1
			fi
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
	image_files=
	screenshot_file=
	if [[ $screenshot -gt 0 ]]; then
		# create screenshot
		umask 077
		screenshot_file=$(mktemp --suff='.png')
		image_file=$screenshot_file
		grim $screenshot_file
	fi

	if [[ -f $image_file ]]; then
		image_opt="-s stretch -i $image_file"

		# try to split the image into pieces fitting for each monitor
		image_files=$(python3 $split_lock_image_script $image_file)

		if [[ $? -eq 0 ]]; then
			# if the splitting was successful, set image_opt
			image_opt="-s stretch"
			for temp_file in $image_files; do
				if [[ $blur -gt 0 ]]; then
					# blur the image parts piece by piece
					temp_fn=$(echo $temp_file | cut -d ':' -f 2)
					convert $temp_fn -resize "12.5%" -blur 0x3 -resize "800%" $temp_fn
				fi
				image_opt="$image_opt -i $temp_file"
			done

		else
			# if the splitting was unsuccessful, blur the entire image
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
				image_opt="-s stretch -i $image_file"
			fi
		fi
	fi

	# lock the screen
	swaylock -f -c $colour $cursor_opt $image_opt

	# if we created a screenshot, delete it again
	[[ -f $screenshot_file ]] && shred -u $screenshot_file
	for image_file in $image_files; do
		shred -u $(echo $image_file | cut -d ':' -f 2)
	done
fi

