#!/bin/bash

# whenever a Screen Change Notify is sent by X11, it's caught by i3,
# which re-organizes its workspaces, and in turn sends out an
# "output" event via its IPC
#
#  we use this notification to restart polybar.
while true; do
	# subscribe commands wait until such an event is sent
	i3-msg -t subscribe '[ "output" ]'
	sleep 1s
	$HOME/.config/polybar/start.sh -k
done

