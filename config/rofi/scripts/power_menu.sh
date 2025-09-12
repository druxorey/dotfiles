#!/bin/bash

function main() {
	rofiOption=$(echo -e "\n⏻\n" | rofi -dmenu -p -i -config ~/.config/rofi/styles/power_styles.rasi)

	case "$rofiOption" in
		"") bspc quit ;;
		"⏻") systemctl poweroff ;;
		"") systemctl reboot ;;
		*) exit 1 ;;
	esac
}

main $@
