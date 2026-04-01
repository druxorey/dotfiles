#!/bin/bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_ERROR="\e[1;31m[ERROR]\e[0m"

declare -r CONFIG_PATH="$HOME/.config/rofi/modules/start_menu.rasi"
declare -r SCRIPTS_PATH="$HOME/.config/rofi/scripts"
declare -r POLYBAR_CONFIG_PATH="$HOME/.config/rofi/polybar/start_menu_polybar.rasi"

function main() {
	local actualDate=$(date +"%H:%M  %A  %d/%m/%Y" | tr '[:lower:]' '[:upper:]')
	declare -a monitor=()

	local configFile""
	if [[ $1 == "polybar" ]]; then
		configFile="$POLYBAR_CONFIG_PATH"
		printf "%b Running in polybar mode: %s\n" "$FORMAT_WARNING" "$configFile"
	else
		configFile="$CONFIG_PATH"
		monitor=(-m -1)
		printf "%b Running in default mode: %s\n" "$FORMAT_WARNING" "$configFile"
	fi

	local rofiOption=$(echo -e "\n󰱼\n\n\n⏻" | rofi -dmenu -p -i "${monitor[@]}" -mesg "$actualDate" -config "$configFile")

	if [[ -z "$rofiOption" ]]; then
		printf "%b No option selected or Rofi closed. Exiting.\n" "${FORMAT_WARNING}"
		exit 0
	fi

	printf "Option selected: %s\n" "$rofiOption"

	case "$rofiOption" in
		"")
			printf "%b Launching App Launcher...\n" "${FORMAT_SUCCESS}"
			rofi -show drun -i "${monitor[@]}" -config ~/.config/rofi/modules/app_launcher.rasi
			;;
		"󰱼")
			printf "%b Launching File Search...\n" "${FORMAT_SUCCESS}"
			rofi -show recursivebrowser -i "${monitor[@]}" -config ~/.config/rofi/modules/file_search.rasi
			;;
		"")
			printf "%b Launching Music Manager...\n" "${FORMAT_SUCCESS}"
			sh "$SCRIPTS_PATH/music_manager.sh"
			;;
		"")
			printf "%b Launching Settings Menu...\n" "${FORMAT_SUCCESS}"
			sh "$SCRIPTS_PATH/settings_menu.sh"
			;;
		"⏻")
			printf "%b Launching Power Manager...\n" "${FORMAT_SUCCESS}"
			sh "$SCRIPTS_PATH/power_manager.sh"
			;;
		*)
			printf "%b Unknown option or aborted.\n" "${FORMAT_ERROR}"
			exit 1
			;;
	esac

	return 0
}

main "$@"
