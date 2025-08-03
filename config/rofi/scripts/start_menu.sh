#!/bin/bash

SCRIPTS_PATH=~/.config/rofi/scripts

function main() {
	runRofi='rofi -dmenu -p -i -config ~/.config/rofi/styles/start_styles.rasi'
	rofiOption=$(echo -e "\n󰀻\n󰱼\n󰂄\n⏻" | $runRofi)

	case "$rofiOption" in
		"") sh $SCRIPTS_PATH/wifi_menu.sh ;;
		"󰀻") rofi -show drun -config ~/.config/rofi/styles/launcher_styles.rasi;;
		"󰱼") rofi -show recursivebrowser -config ~/.config/rofi/styles/files_styles.rasi;;
		"󰂄") sh $SCRIPTS_PATH/energy_menu.sh ;;
		"⏻") sh $SCRIPTS_PATH/power_menu.sh ;;
		*) exit 1 ;;
	esac
}

main $@
