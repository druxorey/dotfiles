#!/bin/bash

function main() {
	dunstctl close-all
	if [ "$(dunstctl is-paused)" = "true" ]; then
		dunstctl set-paused toggle
		notify-send "Toggle notification On" --app-name "Dunst"
	else
		notify-send "Toggle notification Off" --app-name "Dunst"
		sleep 5
		dunstctl set-paused toggle
	fi
	return 0
}

main "$@"
