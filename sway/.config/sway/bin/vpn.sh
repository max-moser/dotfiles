#!/bin/bash

active_vpn=
available_vpns=()
has_available_vpns=0

while read -r line; do
	state=$(echo "$line" | awk '{ print $2 }')
	name=$(echo "$line" | awk '{ $1=$2=""; print substr($0, 3) }')

	if [[ "$state" =~ activated ]]; then
		active_vpn="$name"
	else
		available_vpns+=( "$name" )
		has_available_vpns=1
	fi
done < <(nmcli --fields=TYPE,STATE,NAME connection show | grep '^vpn\W')

if [[ -n "$active_vpn" ]]; then
	# TODO make script more flexible (allow other dmenu replacements than just rofi)
	selection=$(echo -e "disconnect from '$active_vpn'\ncancel" | rofi -dmenu)
	if [[ ! "$selection" =~ cancel ]]; then
		nmcli connection down "$active_vpn"
	fi

elif [[ $has_available_vpns -gt 0 ]]; then
	# TODO same as above
	selection=$(for vpn in "${available_vpns[@]}"; do echo $vpn; done | rofi -dmenu)
	nmcli connection up "$selection"

else
	echo "no vpns available." >&2
fi
