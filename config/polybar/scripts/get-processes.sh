#!/bin/bash

function main() {
	processes=$(ps aux | awk '{print $11 $12}')

	discord=$(echo $processes | grep "discord")
	steam=$(echo $processes  | grep "steam")
	proton=$(echo $processes  | grep "proton")

	output=""

	[ -n "$discord" ] && output="${output} 󰙯  "
	[ -n "$steam" ] && output="${output} 󰓓  "
	[ -n "$proton" ] && output="${output} 󰕣  "

	printf "${output:- }"
}

main $@
