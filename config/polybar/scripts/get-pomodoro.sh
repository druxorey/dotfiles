#!/bin/bash

function main() {
	[[ ! -f /tmp/pomo_time ]] && return 0

	pomodoro=$(ps aux | awk '{print $11 $12}' | grep "pomo" | head -n 1)
	actualTime=$(cat /tmp/pomo_time)

	if [[ "$pomodoro" == "pomo" ]]; then
		printf " $actualTime \n"
		return
	fi
	printf "\n"
}

main "$@"
