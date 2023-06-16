#!/bin/bash
#
# vim: noexpandtab
#
# script for connecting to a Wi-Fi connection via the NetworkManager CLI
# after querying the user which Wi-Fi to connect to

gui=1
min_signal=0

# parse arguments
while getopts "Gghs:" opt; do
	case "${opt}" in
		g)
			gui=1;;
		G)
			gui=0;;
		s)
			if [[ ! "$OPTARG" =~ [0-9]+ ]]; then
				echo "minimum signal strength must be a number" >&2
				exit 1
			elif [[ "$OPTARG" -gt 100 || "$OPTARG" -lt 0 ]]; then
				echo "minimum signal strength must be between 0 and 100" >&2
				exit 1
			else
				min_signal="$OPTARG"
			fi
			;;
		h)
			echo -e "usage: ${0} [OPTION...]\n"
			echo "  -h    show this help screen and exit"
			echo "  -s    set the minimum signal strengh (0-100)"
			echo "  -g|-G enable/disable GUI for asking the user"
			exit
			;;
		*)
			echo "ignoring unknown option: ${opt}" >&2
			;;
	esac
done

# use rofi if GUI is enabled, otherwise use fzf
command="rofi -dmenu -i -p 'Connect to Wi-Fi'"
if [[ "${gui}" -eq 0 ]]; then
	command="fzf --prompt 'Connect to Wi-Fi> '"
fi

# create temporary fifo for piping the nmcli query output to the selector application
temp=$(mktemp -u)
mkfifo -m 600 "$temp"
trap 'rm -f $temp' EXIT

(
	# query NetworkManager for available wifi options
	declare -A available_cons
	while read -r line; do
		signal=$(echo "$line" | cut -d ":" -f 1)
		ssid=$(echo -e "$line" | cut -d ":" -f 2- | sed -Ee 's_\\([:\])_\1_g')

		# deduplicate entries and filter by minimum signal
		if [[ -n "$ssid" && "$signal" -ge "$min_signal" && -z "${available_cons[$ssid]}" ]]; then
			available_cons+=([$ssid]="$signal")
			echo "$ssid" >> "$temp"
		fi
	done < <(nmcli --fields=SIGNAL,SSID --terse device wifi list)

	# the tail/selector pipeline needs at least one value
	# otherwise, the pipeline will hang...
	if [[ "${#available_cons}" -eq 0 ]]; then
		echo "" >> "$temp"
	fi

	# remove the fifo to kill the 'tail --follow=name'
	rm -f "$temp"
) &
pid=$!

# connect with the selected wifi (if one was selected)
if selection=$(tail --follow=name "$temp" 2>/dev/null | eval "${command}"); then
	if [[ -n "${selection}" ]]; then
		nmcli device wifi connect "$selection"
	fi
fi

# wait for the subshell to finish
wait $pid
