#!/bin/bash

function main() {
	processes=$(ps aux | awk '{print $11 $12}')

	discord=$(echo $processes | grep "discord")
	steam=$(echo $processes  | grep "steam")
	proton=$(echo $processes  | grep "proton")
	obs=$(echo $processes | grep -w "obs")
	localsend=$(echo $processes | grep "localsend")

	output=""

	[ -n "$discord" ] && output="${output}󰙯"
	[ -n "$steam" ] && output="${output}   󰓓"
	[ -n "$proton" ] && output="${output}   󰕣"
	[ -n "$obs" ] && output="${output}   󰻃"
	[ -n "$localsend" ] && output="${output}   "

	[ -n "$output" ] && output="  $output   "

	printf "${output:- }"
}

main "$@"
