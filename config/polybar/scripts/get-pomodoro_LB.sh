#!/bin/bash

function main() {
	pomodoro=$(ps aux | awk '{print $11 $12}' | grep "pomo" | head -n 1)

	if [[ $pomodoro == "pomo" ]]; then
		printf ""
		return 0
	fi

	printf "\n"
}

main "$@"
