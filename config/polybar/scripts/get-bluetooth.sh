#!/bin/bash

function main() {
	status=$(bluetoothctl devices Connected  2>/dev/null)

	if [[ $status == "No default controller available" ]] ; then
		printf "󰂲"
	elif [[ -z $status ]]; then
		printf "󰂯"
	else
		printf "󰂱"
	fi
}

main "$@"
