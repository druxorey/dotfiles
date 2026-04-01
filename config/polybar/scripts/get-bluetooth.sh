#!/bin/bash

function main() {
	local status=$(bluetoothctl devices Connected 2>/dev/null)

	if [[ "$status" == "No default controller available" ]] ; then
		printf "󰂲"
	elif [[ -z $status ]]; then
		printf "󰂯"
	else
		printf "󰂱"
	fi

	return 0
}

main "$@"
