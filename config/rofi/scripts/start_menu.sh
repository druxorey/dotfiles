#!/bin/bash

SCRIPTS_PATH=~/.config/rofi/scripts

function main() {
	actualDate=$(date +"%H:%M  %A  %d/%m/%Y" | tr '[:lower:]' '[:upper:]')
	rofiOption=$(echo -e "\n󰱼\n\n\n⏻" | rofi -dmenu -p -i -m -1 -mesg "$actualDate" -config ~/.config/rofi/modules/start_menu.rasi)

	case "$rofiOption" in
		"") rofi -show drun -config ~/.config/rofi/modules/app_launcher.rasi ;;
		"󰱼") rofi -show recursivebrowser -config ~/.config/rofi/modules/file_search.rasi ;;
		"") sh $SCRIPTS_PATH/music_manager.sh ;;
		"") sh $SCRIPTS_PATH/settings_menu.sh ;;
		"⏻") sh $SCRIPTS_PATH/power_manager.sh ;;
		*) exit 1 ;;
	esac
}

main "$@"
