#!/bin/bash

function main() {
	local icons=()

	pgrep -x "discord" > /dev/null && icons+=("󰙯")
	pgrep -x "steam" > /dev/null && icons+=("󰓓")
	pgrep -x "protonvpn-app" > /dev/null && icons+=("󰕣")
	pgrep -x "obs" > /dev/null && icons+=("󰻃")
	pgrep -x "localsend" > /dev/null && icons+=("")

	amixer -D pulse get Capture | grep -q '\[on\]' && icons+=("")

	if [ ${#icons[@]} -gt 0 ]; then
		echo "${icons[*]}"
	else
		echo ""
	fi

	return 0
}

main "$@"
