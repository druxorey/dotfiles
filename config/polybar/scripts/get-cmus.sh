#!/bin/bash

ARTIST_MAX_LENGTH=50

function main() {
	status=$(cmus-remote -Q 2>/dev/null)

	if [[ -z $status ]]; then
		printf " "
		exit 0
	fi

	state=$(echo "$status" | grep "status" | awk '{print $2}')
	artist=$(echo "$status" | grep "tag artist" | cut -d ' ' -f 3-)
	title=$(echo "$status" | grep "tag title" | cut -d ' ' -f 3-)

	if [ ${#artist} -gt $ARTIST_MAX_LENGTH ]; then
		artist=$(echo "$artist" | cut -c 1-$ARTIST_MAX_LENGTH)...
	fi

	if [ "$state" = "playing" ]; then
		printf "   %s  -  %s " "$artist" "$title"
	elif [ "$state" = "paused" ]; then
		printf "   %s  -  %s " "$artist" "$title"
	else
		printf "   Stopped"
	fi
}

main "$@"
