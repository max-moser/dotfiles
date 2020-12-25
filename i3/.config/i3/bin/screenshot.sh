#!/bin/bash

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

line_style='style=dash,color=red,width=2'
file_name='%Y-%m-%d-%s_screenshot_$wx$h.png'
clip_cmd='xclip -t image/png -selection clipboard $f; shred -u $f'
mv_cmd='mv $f $$HOME/Pictures/'

if [[ $fancy -gt 0 ]]; then
	gnome-screenshot -i

elif [[ $interactive -gt 0 && $clipboard -gt 0 ]]; then
	umask 077
	file_name=$(mktemp --suff='.png')
	scrot -s -f --line="$line_style" -o "$file_name" -e "$clip_cmd"

elif [[ $interactive -gt 0 ]]; then
	scrot -s -f --line="$line_style" "$file_name" -e "$mv_cmd"

elif [[ $clipboard -gt 0 ]]; then
	umask 077
	file_name=$(mktemp --suff='.png')
	scrot -o "$file_name" -e "$clip_cmd"

else
	scrot "$file_name" -e "$mv_cmd"
fi

