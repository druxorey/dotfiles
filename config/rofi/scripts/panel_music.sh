#!/bin/bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_ERROR="\e[1;31m[ERROR]\e[0m"

declare -r ROFI_CONFIG="$HOME/.config/rofi/modules/panel_music.rasi"
declare -r THUMBNAIL_PATH="/tmp/thumbnail.jpg"
declare -i OPTION=2

function manageLofiStatus() {
	case "$1" in
		"reload") pkill -x "lofi"; lofi -d 50 & ;;
		"on"    ) cmus-remote --stop; lofi -d 50 & sleep 1 ;;
		"off"   ) pkill -x "lofi" ;;
	esac
	return 0
}


function manageLofiVolume() {
	local sinkId=$(pactl list sink-inputs | awk '/Sink Input #/{id=$3} /application.process.binary = "ffplay"/{print id; exit}' | tr -d '#')
	[[ -z "$sinkId" ]] && printf "%b Lofi Radio is not running.\n" "$FORMAT_WARNING" >&2 && return 1
	if [[ "$1" == "mute" ]]; then
		pactl set-sink-input-mute "$sinkId" toggle || printf "%b Failed to toggle Lofi mute\n" "$FORMAT_ERROR" >&2
	else
		pactl set-sink-input-volume "$sinkId" $1 || printf "%b Failed to adjust Lofi volume\n" "$FORMAT_ERROR" >&2
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
	while [[ $OPTION -ne -1 ]]; do
		local status=$(cmus-remote -Q 2>/dev/null)

		[[ -z $status ]] && printf "%b Cmus is not running.\n" "$FORMAT_WARNING"

		local artist=$(echo "$status" | grep "tag artist" | cut -d ' ' -f 3-)
		local title=$(echo "$status" | grep "tag title" | cut -d ' ' -f 3-)
		local message=$(printf "%s - %s" "$artist" "$title" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')

		local filePath=$(echo "$status" | grep "file" | cut -d ' ' -f 2-)
		local reproducerState=""
		local lofiSelected=""
		local options=""

		local state=$(echo "$status" | grep "status" | awk '{print $2}')
		printf "State:   %s\nArtist:  %s\nTitle:   %s\nPath:    %s\n" "${state:-N/A}" "${artist:-Unknown}" "${title:-Unknown}" "${filePath:-N/A}"

		if pgrep -x "lofi" > /dev/null; then
			reproducerState="󰎊"
			lofiSelected="-u 4"
			message="Lofi Radio"
			options="󰝟\n󰝞\n󰑓\n󰝝\n󰟎"
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

		[[ -z "$options" ]] && options="\n󰒮\n$reproducerState\n󰒭\n󰋋"
		[[ -z "$lofiSelected" ]] && getThumbnail "$filePath"

		local rofiOption=$(echo -e "$options" | rofi -dmenu -m -1 $lofiSelected -mesg "$message" -selected-row $OPTION -config $ROFI_CONFIG)

		case "$rofiOption" in
			"󰝟") manageLofiVolume "mute" ; OPTION=0 ;;
			"󰝞") manageLofiVolume "-10%" ; OPTION=1 ;;
			"󰝝") manageLofiVolume "+10%" ; OPTION=3 ;;
			"") cmus-remote --stop ; OPTION=0 ;;
			"󰒮") cmus-remote --prev ; OPTION=1 ;;
			"󰒭") cmus-remote --next ; OPTION=3 ;;
			"󰑓") manageLofiStatus reload ;;
			"󰋋") manageLofiStatus on  ;;
			"󰟎") manageLofiStatus off && exit 0 ;;
			"") bspc desktop -f ^5 ; kitty cmus & exit 0 ;;
			"$reproducerState") cmus-remote --pause && OPTION=2 ;;
			*) printf "%b No option selected. Exiting.\n" "${FORMAT_WARNING}" && exit 0 ;;
		esac
	done

	return 0
}

main "$@"
