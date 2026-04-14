#!/bin/bash

declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"

declare -r ROFI_CONFIG="$HOME/.config/rofi/modules/panel_power.rasi"

function main() {
	local message=$(uptime -p)
	printf "System uptime: %s\n" "$message"

	[[ ! $1 == "polybar" ]] && monitor="-m -1"

	local rofiOption=$(echo -e "\n\n⏻\n\n󰍃" | rofi -dmenu $monitor -u 0 -mesg "$message" -config $ROFI_CONFIG)

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
