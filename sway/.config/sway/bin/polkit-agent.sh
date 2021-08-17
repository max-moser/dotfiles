#!/bin/bash
# starts one of the polkit authentication agents, if available
# https://wiki.archlinux.org/title/Polkit#Authentication_agents

agents=()
agents+=( "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1" )
agents+=( "/usr/lib/polkit-kde-authentication-agent-1" )
agents+=( "/usr/lib/mate-polkit/polkit-mate-authentication-agent-1" )
agents+=( "/usr/lib/xfce-polkit/xfce-polkit" )
agents+=( "/usr/bin/lxqt-policykit-agent" )
agents+=( "/usr/bin/lxpolkit" )
agents+=( "/usr/bin/polkit-efl-authentication-agent-1" )
agents+=( "/usr/lib/ts-polkitagent" )

for agent in ${agents[@]}; do
	agent_path=$(which $agent)
	if [[ -x $agent_path ]]; then
		echo "executing $agent_path..."
		exec $agent_path
	fi
done

echo "no agents found." >&2
exit 1
