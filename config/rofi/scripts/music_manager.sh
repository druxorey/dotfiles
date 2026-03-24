#!/bin/bash

FORMAT_ERROR="\e[1;31m[ERROR]"
FORMAT_SUCCESS="\e[1;32m[SUCCESS]"
FORMAT_WARNING="\e[1;33m[WARNING]"
FORMAT_END="\e[0m"

OPTION=2

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
	status=$(cmus-remote -Q 2>/dev/null)

	if [[ -z $status ]]; then
		printf "%b Cmus is not running%b\n" "$FORMAT_WARNING" "$FORMAT_END"
	fi

	state=$(echo "$status" | grep "status" | awk '{print $2}')
	artist=$(echo "$status" | grep "tag artist" | cut -d ' ' -f 3-)
	title=$(echo "$status" | grep "tag title" | cut -d ' ' -f 3-)
	message="$artist - $title"

	isLofiRunning=$(pgrep -x "lofi" > /dev/null && echo true || echo false)

	if [ "$isLofiRunning" = false ] && getThumbnail "$title"; then
		printf "${FORMAT_SUCCESS} Thumbnail updated for '%s' ${FORMAT_END}\n" "$title"
	else
		printf "${FORMAT_ERROR} No thumbnail found for '%s' ${FORMAT_END}\n" "$title"
	fi

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

	rofiOption=$(echo -e "\n󰒮\n$reproducerState\n󰒭\n󰋋" | rofi -dmenu -p -i -m -1 $lofiSelected -mesg "$message" -selected-row $OPTION -config ~/.config/rofi/modules/music_manager.rasi)

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
