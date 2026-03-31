#!/bin/bash

declare FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare FORMAT_ERROR="\e[1;31m[ERROR]\e[0m"

declare CONFIG_FILE="$HOME/.config/rofi/modules/music_manager.rasi"
declare THUMBNAIL_PATH="/tmp/thumbnail.jpg"
declare OPTION=2

function checkLofi() {
	if pgrep -x "lofi" > /dev/null; then
		pkill -x "lofi"
		return 0
	else
		cmus-remote --stop
		kitty lofi
	fi

	return 0
}

function getThumbnail() {
	rm -f "$THUMBNAIL_PATH"

	if [ -z "$1" ]; then
		printf "%b Cannot search for thumbnail: File not found\n" "$FORMAT_ERROR" >&2
		return 1
	fi

	exiftool -b -Picture "$1" > "$THUMBNAIL_PATH"

	if [ ! -s "$THUMBNAIL_PATH" ]; then
		rm -f "$THUMBNAIL_PATH"
		printf "%b Failed to extract thumbnail from '%s'\n" "$FORMAT_ERROR" "$1"
		return 1
	fi

	printf "%b Thumbnail updated for '%s'\n" "$FORMAT_SUCCESS" "$title"

	return 0
}


function main() {
	local status=$(cmus-remote -Q 2>/dev/null)

	[[ -z $status ]] && printf "%b Cmus is not running.\n" "$FORMAT_WARNING"

	local artist=$(echo "$status" | grep "tag artist" | cut -d ' ' -f 3-)
	local title=$(echo "$status" | grep "tag title" | cut -d ' ' -f 3-)
	local message=$(printf "%s - %s" "$artist" "$title" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')

	local filePath=$(echo "$status" | grep "file" | cut -d ' ' -f 2-)
	local reproducerState=""
	local lofiSelected=""

	printf "State:   %s\nArtist:  %s\nTitle:   %s\nPath:    %s\n" "${state:-N/A}" "${artist:-Unknown}" "${title:-Unknown}" "${filePath:-N/A}"

	local state=$(echo "$status" | grep "status" | awk '{print $2}')
	if pgrep -x "lofi" > /dev/null; then
		reproducerState="󰎊"
		lofiSelected="-u 4"
		message="Lofi Radio"
	elif [ "$state" = "playing" ]; then
		reproducerState=""
	elif [ "$state" = "paused" ]; then
		reproducerState=""
	elif [ "$state" = "stopped" ]; then
		reproducerState=""
	else
		reproducerState=""
		message="No music playing"
	fi

	[[ -z "$lofiSelected" ]] && getThumbnail "$filePath"

	local rofiOption=$(echo -e "\n󰒮\n$reproducerState\n󰒭\n󰋋" | rofi -dmenu -p -i -m -1 $lofiSelected -mesg "$message" -selected-row $OPTION -config $CONFIG_FILE)

	case "$rofiOption" in
		"") cmus-remote --stop && OPTION=0 ;;
		"󰒮") cmus-remote --prev && OPTION=1 ;;
		"󰒭") cmus-remote --next && OPTION=3 ;;
		"󰋋") bspc desktop -f ^5 ; checkLofi  & exit 0 ;;
		"") bspc desktop -f ^5 ; kitty cmus & exit 0 ;;
		"$reproducerState") cmus-remote --pause && OPTION=2 ;;
		*) exit 1 ;;
	esac

	return 0
}

while [[ $OPTION -ne -1 ]]; do
	main "$@"
done
