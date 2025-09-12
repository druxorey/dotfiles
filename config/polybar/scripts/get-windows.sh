#!/bin/bash

function main() {
	windows=$(bspc query -N -d focused | wc -l)

	if bspc query -T -d | grep -q "monocle"; then
		mod=$(( windows / 2 ))

		if [[ windows -ge 4 ]]; then
			windows=$(( windows - mod ))
		elif [[ windows -ge 3 ]]; then
			windows=$(( windows - 1 ))
		fi

		printf $windows
	else
		printf "\n"
		return 0
	fi

}

main $@
