#!/bin/bash

declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"

declare -r ROFI_CONFIG="$HOME/.config/rofi/modules/menu_start.rasi"
declare -r POLYBAR_CONFIG="$HOME/.config/rofi/polybar/menu_start.rasi"
declare -r SCRIPTS_PATH="$HOME/.config/rofi/scripts"

function main() {
	printf "Initializing start menu...\n"

	local message=$(date +"%H:%M  %A  %d/%m/%Y" | tr '[:lower:]' '[:upper:]')
	local configFile""
	declare -a monitor=()

	if [[ $1 == "polybar" ]]; then
		configFile="$POLYBAR_CONFIG"
		printf "%b Running in polybar mode: %s\n" "$FORMAT_WARNING" "$configFile"
	else
		configFile="$ROFI_CONFIG"
		monitor=(-m -1)
		printf "%b Running in default mode: %s\n" "$FORMAT_WARNING" "$configFile"
	fi

	local rofiOption=$(echo -e "󰱼\n\n\n\n⏻" | rofi -dmenu "${monitor[@]}" -mesg "$message" -config "$configFile")

	if [[ -z "$rofiOption" ]]; then
		printf "%b No option selected. Exiting.\n" "$FORMAT_WARNING"
		exit 0
	fi

	printf "Option selected: %s\n" "$rofiOption"

	case "$rofiOption" in
		"󰱼") rofi -show recursivebrowser "${monitor[@]}" -config ~/.config/rofi/modules/launcher_files.rasi ;;
		"") sh "$SCRIPTS_PATH/menu_utilities.sh" ;;
		"") sh "$SCRIPTS_PATH/panel_music.sh" ;;
		"") sh "$SCRIPTS_PATH/menu_settings.sh" ;;
		"⏻") sh "$SCRIPTS_PATH/panel_power.sh" ;;
		*)   exit 1 ;;
	esac

	return 0
}

main "$@"
