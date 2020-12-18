#!/bin/bash

if [[ -f $HOME/.screenlayout/setup.sh ]]; then
	$HOME/.screenlayout/setup.sh
fi

for script in $HOME/.config/i3/bin/monitors/*; do
	if [[ -x $script ]]; then
		$script
	fi
done

