#!/bin/bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"

declare -r ROFI_CONFIG="$HOME/.config/rofi/modules/panel_display.rasi"

function main() {
	local message="Select display configuration"

	declare -a displayNames
	declare -a displayCommands

	displayNames[0]="Laptop Only (Disconnect HDMI)"
	displayNames[1]="Extend: HDMI Left of Laptop"
	displayNames[2]="Extend: HDMI Right of Laptop"
	displayNames[3]="Clone: HDMI Same as Laptop"

	displayCommands[0]="xrandr --output eDP-1 --auto --primary --output HDMI-1 --off"
	displayCommands[1]="xrandr --output eDP-1 --auto --primary --output HDMI-1 --auto --left-of eDP-1"
	displayCommands[2]="xrandr --output eDP-1 --auto --primary --output HDMI-1 --auto --right-of eDP-1"
	displayCommands[3]="xrandr --output eDP-1 --auto --primary --output HDMI-1 --auto --same-as eDP-1"

	local selectedIndex=$(printf "%s\n" "${displayNames[@]}" | rofi -dmenu -format i -m -1 -mesg "$message" -config $ROFI_CONFIG)

	if [[ -z "$selectedIndex" ]]; then
		printf "%b No option selected. Exiting.\n" "$FORMAT_WARNING"
		exit 0
	fi

	local selectedName="${displayNames[$selectedIndex]}"
	local selectedCommand="${displayCommands[$selectedIndex]}"

	printf "Option selected: %s\n" "$selectedName"
	printf "%b Applying configuration...\n" "$FORMAT_SUCCESS"

	eval "$selectedCommand" && bspc wm -r

	return 0
}

main "$@"
