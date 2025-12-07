#!/bin/bash

function main() {
	uptime=$(uptime -p)

	[[ ! $1 == "polybar" ]] && monitor="-m -1"

	rofiOption=$(echo -e "\n⏻\n\n" | rofi -dmenu -p -i $monitor -u 0 -mesg "$uptime" -config ~/.config/rofi/modules/power_manager.rasi)

	case "$rofiOption" in
		"") ;;
		"⏻") systemctl poweroff ;;
		"") systemctl reboot ;;
		"") bspc quit ;;
		*) exit 1 ;;
	esac
}

main "$@"
