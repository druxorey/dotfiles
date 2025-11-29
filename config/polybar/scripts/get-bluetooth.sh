#!/bin/bash

function main() {
	status=$(bluetoothctl show 2>/dev/null)

	if [ $? -ne 0 ]; then
		printf "󰂲"
	elif echo "$status" | grep -q "Endpoint"; then
		printf "󰂱"
	else
		printf "󰂯"
	fi
}

main "$@"
