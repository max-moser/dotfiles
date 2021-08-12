#!/bin/bash

grimshot=$HOME/.config/sway/bin/grimshot

interactive=0
output=0
clipboard=0
edit=0
fancy=0
while getopts "efico" opt; do
	case $opt in
		e)
			edit=1
			;;
		f)
			fancy=1
			;;
		i)
			interactive=1
			;;
		c)
			clipboard=1
			;;
		o)
			output=1
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

elif [[ $output -gt 0 && $edit -gt 0 ]]; then
	$grimshot edit output

elif [[ $output -gt 0 && $clipboard -gt 0 ]]; then
	$grimshot copy output

elif [[ $output -gt 0 ]]; then
	$grimshot save output $filename

elif [[ $interactive -gt 0 && $edit -gt 0 ]]; then
	$grimshot edit area

elif [[ $interactive -gt 0 && $clipboard -gt 0 ]]; then
	$grimshot copy area

elif [[ $interactive -gt 0 ]]; then
	$grimshot save area $filename

elif [[ $edit -gt 0 ]]; then
	$grimshot edit screen

elif [[ $clipboard -gt 0 ]]; then
	$grimshot copy screen

else
	$grimshot save screen $filename
fi

