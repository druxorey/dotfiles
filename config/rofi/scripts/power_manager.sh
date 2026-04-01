#!/bin/bash

declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r CONFIG_FILE="$HOME/.config/rofi/modules/power_manager.rasi"

function main() {
	local uptime=$(uptime -p)
	printf "System uptime: %s\n" "$uptime"

	[[ ! $1 == "polybar" ]] && monitor="-m -1"

	local rofiOption=$(echo -e "\n\n⏻\n\n󰍃" | rofi -dmenu -p -i $monitor -u 0 -mesg "$uptime" -config $CONFIG_FILE)

	if [[ -z "$rofiOption" ]]; then
		printf "%b No option selected or Rofi closed. Exiting.\n" "$FORMAT_WARNING"
		exit 0
	fi

	case "$rofiOption" in
		"") ;;
		"") dm-tool lock ;;
		"⏻") systemctl poweroff ;;
		"") systemctl reboot ;;
		"󰍃") bspc quit ;;
		*) exit 1 ;;
	esac

	return 0
}

main "$@"
