#!/bin/bash

declare FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare FORMAT_ERROR="\e[1;31m[ERROR]\e[0m"

declare CONFIG_FILE="$HOME/.config/rofi/modules/wallpaper_manager.rasi"

declare DARK_WALLPAPERS_PATH="$HOME/Pictures/Wallpapers/Dracula"
declare LIGHT_WALLPAPERS_PATH="$HOME/Pictures/Wallpapers/Alucard"
declare ACTUAL_WALLPAPER_PATH="$HOME/.local/share/wallpaper_actual.png"
declare DARK_LINK="$HOME/.local/share/wallpaper_dark.png"
declare LIGHT_LINK="$HOME/.local/share/wallpaper_light.png"

function main() {
	local wallpapersPath=$LIGHT_WALLPAPERS_PATH
	local message="Wallpapers for Alucard"
	local targetLink=$LIGHT_LINK

	if [[ $(cat "$HOME/.cache/actual_theme") == "dark" ]]; then
		wallpapersPath=$DARK_WALLPAPERS_PATH
		message="Wallpapers for Dracula"
		targetLink=$DARK_LINK
	fi

	printf "Loading wallpapers from: %s\n" "$wallpapersPath"

	local selection=$(for img in "$wallpapersPath"/*.{jpg,jpeg,png}; do
		[ -e "$img" ] || continue
		echo -en "$(basename "$img")\0icon\x1f$img\n"
	done | rofi -dmenu -i -m -1 -show-icons -p "Picture:" -mesg "$message" -config $CONFIG_FILE)

	if [ -n "$selection" ]; then
		ln -sf "$wallpapersPath/$selection" "$targetLink"
		ln -sf "$targetLink" "$ACTUAL_WALLPAPER_PATH"

		if feh --bg-fill "$ACTUAL_WALLPAPER_PATH"; then
			printf "%b Wallpaper set to: %s\n" "$FORMAT_SUCCESS" "$selection"
		else
			printf "%b Failed to set wallpaper: %s\n" "$FORMAT_ERROR" "$selection"
			return 1
		fi
	else
		printf "%b No wallpaper selected\n" "$FORMAT_WARNING"
	fi
	return 0
}

main "$@"
