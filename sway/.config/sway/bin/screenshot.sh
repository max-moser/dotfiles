#!/bin/bash

grimshot=/usr/share/sway/scripts/grimshot
[[ ! -f $grimshot || ! -x $grimshot ]] && grimshot=$HOME/.config/sway/bin/grimshot

interactive=0
clipboard=0
fancy=0
while getopts "fic" opt; do
	case $opt in
		f)
			fancy=1
			;;
		i)
			interactive=1
			;;
		c)
			clipboard=1
			;;
		*)
			echo "ignoring unknown option $opt" >&2
			;;
	esac
done

# determine the file path (including directory) of the screenshot
directory=${XDG_SCREENSHOTS_DIR:-${XDG_PICTURES_DIR:-$HOME/Pictures}}
[[ ! -d $directory ]] && mkdir -p $directory
filename="$directory/$(date '+%Y-%m-%d_%H-%M-%S')_screenshot.png"

if [[ $fancy -gt 0 ]]; then
	gnome-screenshot -i

elif [[ $interactive -gt 0 && $clipboard -gt 0 ]]; then
	$grimshot copy area

elif [[ $interactive -gt 0 ]]; then
	$grimshot save area $filename

elif [[ $clipboard -gt 0 ]]; then
	$grimshot copy screen

else
	$grimshot save screen $filename
fi

