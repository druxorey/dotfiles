#!/bin/bash

declare FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare FORMAT_ERROR="\e[1;31m[ERROR]\e[0m"

declare CONFIG_FILE="$HOME/.config/rofi/modules/music_manager.rasi"
declare OPTION=2

function checkCmus() {
	bspc desktop -f ^5
	if [[ -z $1 ]]; then
		bspc desktop -f ^5 && kitty cmus
	fi
}


function getThumbnail() {
	cleanTitle=$(echo "$1" | sed 's/^[^a-zA-Z]*//;s/[^a-zA-Z]*$//')
	thumbnail=$(find ~/Music/ -type f -iname "*${cleanTitle}*")
    ffmpeg -y -i "$thumbnail" -an -vcodec copy "/tmp/thumbnail.jpg" 2>/dev/null || rm -f "/tmp/thumbnail.jpg"
}


function main() {
	local status=$(cmus-remote -Q 2>/dev/null)

	if [[ -z $status ]]; then
		printf "%b Cmus is not running%b\n" "$FORMAT_WARNING" "$FORMAT_END"
	fi

	local state=$(echo "$status" | grep "status" | awk '{print $2}')
	local artist=$(echo "$status" | grep "tag artist" | cut -d ' ' -f 3-)
	local title=$(echo "$status" | grep "tag title" | cut -d ' ' -f 3-)

	local message="$artist - $title"
	local isLofiRunning=$(pgrep -x "lofi" > /dev/null && echo true || echo false)

	if [ "$isLofiRunning" = false ] && getThumbnail "$title"; then
		printf "%b Thumbnail updated for '%s'\n" "$FORMAT_SUCCESS" "$title"
	else
		printf "%b No thumbnail found for '%s'\n" "$FORMAT_ERROR" "$title"
	fi

	local reproducerState=""
	local lofiSelected=""
	if [ "$isLofiRunning" == true ]; then
		message="Lofi radio"
		reproducerState="󰎊"
		lofiSelected="-u 4"
	elif [ "$state" = "playing" ]; then
		reproducerState=""
	elif [ "$state" = "paused" ]; then
		reproducerState=""
	else
		reproducerState=""
		message="No music playing"
	fi

	local rofiOption=$(echo -e "\n󰒮\n$reproducerState\n󰒭\n󰋋" | rofi -dmenu -p -i -m -1 $lofiSelected -mesg "$message" -selected-row $OPTION -config $CONFIG_FILE)

	case "$rofiOption" in
		"") cmus-remote --stop && OPTION=0 ;;
		"󰒮") cmus-remote --prev  && OPTION=1 ;;
		"") checkCmus "$status" && OPTION=-1 ;;
		"$reproducerState") cmus-remote --pause && OPTION=2 ;;
		"󰒭") cmus-remote --next  && OPTION=3 ;;
		"󰋋") cmus-remote --stop ; kitty lofi  && OPTION=-1 ;;
		*) exit 1 ;;
	esac
}

while [[ $OPTION -ne -1 ]]; do
	main "$@"
done
