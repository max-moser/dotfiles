#!/bin/bash
#
# vim: noexpandtab
#
# script for (de-)activating a VPN connection via the NetworkManager CLI
# after querying the user which VPN to connect to/disconnect from via rofi
#
# an assumption is that a user usually wants to connect only to one VPN at a time

active_vpns=()
available_vpns=()
connect=1
force_disconnect=0
force_connect=0

# parse arguments
while getopts "cdh" opt; do
	case "${opt}" in
		c)
			force_connect=1
			;;
		d)
			force_disconnect=1
			;;
		h)
			echo -e "usage: ${0} [OPTION...]\n"
			echo "  -c    force 'connect' action"
			echo "  -d    force 'disconnect' action"
			echo "  -h    show this help screen and exit"
			exit
			;;
		*)
			echo "ignoring unknown option: ${opt}" >&2
			;;
	esac
done

if [[ "${force_connect}" -gt 0 && "${force_disconnect}" -gt 0 ]]; then
	echo "error: cannot force connect and disconnect at the same time" >&2
	exit 1
fi

# query NetworkManager for available/active VPNs
while read -r line; do
	state=$(echo "$line" | awk '{ print $2 }')
	name=$(echo "$line" | awk '{ $1=$2=""; print substr($0, 3) }')

	if [[ "$state" =~ activated ]]; then
		active_vpns+=( "$name" )
		connect=0
	else
		available_vpns+=( "$name" )
	fi
done < <(nmcli --fields=TYPE,STATE,NAME connection show | grep '^vpn\W')

# override the action if forced
if [[ "${force_connect}" -gt 0 ]]; then
	connect=1
elif [[ "${force_disconnect}" -gt 0 ]]; then
	connect=0
fi

# perform the selected action
# if an action was forced with no options, the selection will be empty... which is okay
if [[ "${connect}" -eq 0 ]]; then
	if selection=$(for vpn in "${active_vpns[@]}"; do echo "${vpn}"; done | rofi -dmenu -p "Disconnect from VPN"); then
		if [[ -n "${selection}" ]]; then
			nmcli connection down "$selection"
		fi
	fi

elif [[ "${connect}" -gt 0 ]]; then
	if selection=$(for vpn in "${available_vpns[@]}"; do echo "${vpn}"; done | rofi -dmenu -p "Connect to VPN"); then
		if [[ -n "${selection}" ]]; then
			nmcli connection up "$selection"
		fi
	fi

else
	echo "No VPNs available." >&2
fi
