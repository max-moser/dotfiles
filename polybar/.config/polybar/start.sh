#!/bin/sh

if [[ -z $(pgrep -x polybar) ]]; then
	BAR=max

	for m in $(polybar --list-monitors | cut -d ":" -f 1); do
		MONITOR=$m polybar --reload $BAR &
		sleep 0.1
	done
else
	polybar-msg cmd restart
fi

