#!/bin/bash

function main() {
	uptime=$(uptime -p)
	rofiOption=$(echo -e "\n⏻\n\n" | rofi -dmenu -p -i -m -1 -u 0 -mesg "$uptime" -config ~/.config/rofi/modules/power_manager.rasi)

	case "$rofiOption" in
		"") ;;
		"⏻") systemctl poweroff ;;
		"") systemctl reboot ;;
		"") bspc quit ;;
		*) exit 1 ;;
	esac
}

main "$@"
