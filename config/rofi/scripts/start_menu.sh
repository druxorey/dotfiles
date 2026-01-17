#!/bin/bash

SCRIPTS_PATH="$HOME/.config/rofi/scripts"
CONFIG_PATH="$HOME/.config/rofi/modules/start_menu.rasi"
POLYBAR_CONFIG_PATH="$HOME/.config/rofi/polybar/start_menu_polybar.rasi"

function main() {
	actualDate=$(date +"%H:%M  %A  %d/%m/%Y" | tr '[:lower:]' '[:upper:]')

	if [[ $1 == "polybar" ]]; then
		configFile="$POLYBAR_CONFIG_PATH"
	else
		configFile="$CONFIG_PATH"
		monitor="-m -1"
	fi

	rofiOption=$(echo -e "\n󰱼\n\n\n⏻" | rofi -dmenu -p -i $monitor -mesg "$actualDate" -config "$configFile")

	case "$rofiOption" in
		"") rofi -show drun -i $monitor -config ~/.config/rofi/modules/app_launcher.rasi ;;
		"󰱼") rofi -show recursivebrowser -i $monitor -config ~/.config/rofi/modules/file_search.rasi ;;
		"") sh "$SCRIPTS_PATH/music_manager.sh" ;;
		"") sh "$SCRIPTS_PATH/settings_menu.sh" ;;
		"⏻") sh "$SCRIPTS_PATH/power_manager.sh" ;;
		*) exit 1 ;;
	esac
}

main "$@"
