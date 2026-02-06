#!/bin/bash

function main() {
	local icons=()
	local processes
	processes=$(ps aux)

	echo "$processes" | grep -q "discord" && icons+=("󰙯")
	echo "$processes" | grep -q "steam" && icons+=("󰓓")
	echo "$processes" | grep -q "proton" && icons+=("󰕣")
	echo "$processes" | grep -q -w "obs" && icons+=("󰻃")
	echo "$processes" | grep -q "localsend" && icons+=("")

	if [ ${#icons[@]} -gt 0 ]; then
		local IFS="@"
		local output="${icons[*]}"
		printf "%s" "${output//@/    }"
	else
		printf "\n"
	fi
}

main "$@"
