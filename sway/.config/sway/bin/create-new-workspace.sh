#!/bin/bash

ws_json=$(swaymsg -t get_workspaces -r)
max_num=
cnt=0
bound=10

while [[ $cnt -le $bound ]]; do
	num=$(echo $ws_json | jq ".[$cnt].num")
	[[ "$num" = "null" ]] && break
	[[ "$num" -gt "$max_num" ]] && max_num=$num
	cnt=$(( $cnt + 1 ))
done

[[ ! -z "$max_num" ]] && swaymsg workspace number $(( $max_num + 1 ))

