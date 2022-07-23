#!/bin/bash

fno () {
	if [[ $# -lt 1 ]]; then
		echo "usage: $0 STRING"

	else

		string="$@"
		results=$(grep -EInri "$string")
		results=("${(f)results}")
		integer num_res=${#results}
		selected=

		if [[ $num_res -eq 1 ]]; then

			selected=${results[1]}

		elif [[ $num_res -gt 1 ]]; then

			print "found $num_res result(s):"

			# list the options
			integer i=0
			for res in $results; do
				i=$(( i + 1 ))
				print "$i) $res"
			done

			# query the user until they supply something valid
			sel=0
			integer cnt=0
			while [[ ! "$sel" =~ [1-9]+ || "$sel" -lt 1 || "$sel" -gt $num_res ]]; do
				[[ $cnt -gt 0 ]] && print "invalid input ($sel)..."
				print -n "select file (1-$num_res): "
				read sel
				cnt=$(( cnt + 1 ))
                [[ -z "${sel}" ]] && sel=1
			done

			selected=${results[$sel]}

		fi

		if [[ ! -z $selected ]]; then
			file="$(echo $selected | cut -d ":" -f 1)"
			line="+$(echo $selected | cut -d ":" -f 2)"
			nvim $file $line
		fi
	fi
}

