#!/bin/bash

declare FORMAT_SUCCESS="\e[1;32m[SUCCESS]"
declare FORMAT_WARNING="\e[1;33m[WARNING]"
declare FORMAT_ERROR="\e[1;31m[ERROR]"
declare FORMAT_RESET="\e[0m"

declare DARK_WALLPAPERS_PATH="$HOME/Pictures/Wallpapers/Dracula"
declare LIGHT_WALLPAPERS_PATH="$HOME/Pictures/Wallpapers/Alucard"
declare ACTUAL_WALLPAPER_PATH="$HOME/.local/share/wallpaper_actual.png"
declare DARK_LINK="$HOME/.local/share/wallpaper_dark.png"
declare LIGHT_LINK="$HOME/.local/share/wallpaper_light.png"

function main() {
	if [[ $(cat "$HOME/.cache/actual_theme") == "dark" ]]; then
		wallpapersPath=$DARK_WALLPAPERS_PATH
		message="Wallpapers for Dracula"
		targetLink=$DARK_LINK
	else
		wallpapersPath=$LIGHT_WALLPAPERS_PATH
		message="Wallpapers for Alucard"
		targetLink=$LIGHT_LINK
	fi

	printf "Loading wallpapers from: %s\n" "$wallpapersPath"

	selection=$(for img in "$wallpapersPath"/*.{jpg,jpeg,png}; do
		[ -e "$img" ] || continue
		fileName=$(basename "$img")
		echo -en "$fileName\0icon\x1f$img\n"
	done | rofi -dmenu -i -m -1 -show-icons -p "Picture:" -mesg "$message" -config ~/.config/rofi/modules/wallpaper_manager.rasi)

	if [ -n "$selection" ]; then
		fullPath="$wallpapersPath/$selection"

		ln -sf "$fullPath" "$targetLink"
		ln -sf "$targetLink" "$ACTUAL_WALLPAPER_PATH"

		if feh --bg-fill "$ACTUAL_WALLPAPER_PATH"; then
			printf "%b Wallpaper set to: %b%s\n" "$FORMAT_SUCCESS" "$selection" "$FORMAT_RESET"
		else
			printf "%b Failed to set wallpaper: %b%s\n" "$FORMAT_ERROR" "$selection" "$FORMAT_RESET"
			return 1
		fi
	else
		printf "%b No wallpaper selected%b\n" "$FORMAT_WARNING" "$FORMAT_RESET"
	fi
	return 0
}

main "$@"
