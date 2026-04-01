#!/bin/bash

function main() {
	local desktopStatus=$(bspc query -T -d)

	if [[ "$desktopStatus" != *"\"layout\":\"monocle\""* ]]; then
		printf "\n"
		return 0
	fi

	local windows=$(bspc query -N -d focused | wc -l)

	if (( windows >= 4 )); then
		windows=$(( windows - (windows / 2) ))
	elif (( windows == 3 )); then
		windows=2
	fi

	printf "%s" "$windows"

	return 0
}

main "$@"
