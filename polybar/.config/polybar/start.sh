#!/bin/bash

kill_polybar=0
bar=max
while getopts "kb:" opt; do
	case $opt in
		k)
			kill_polybar=1
			;;
		b)
			bar=$OPTARG
			;;
		*)
			echo "ignored unknown option: $opt" >&2
			;;
	esac
done

if [[ -z $(pgrep -x polybar) ]]; then
	for m in $(polybar --list-monitors | cut -d ":" -f 1); do
		monitor=$m polybar --reload $bar &
		sleep 0.1
	done

elif [[ $kill_polybar -ge 1 ]]; then
	killall polybar
	sleep 0.5
	exec $0 -b $bar

else
	polybar-msg cmd restart
fi

