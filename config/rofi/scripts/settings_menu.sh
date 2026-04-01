#!/bin/bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"

declare -r CONFIG_FILE="$HOME/.config/rofi/modules/settings_menu.rasi"
declare -r SCRIPTS_PATH=$HOME/.config/rofi/scripts

function toggleAirplaneMode() {
	printf "Checking network status...\n"
	wifi_status=$(nmcli radio wifi)
	bluetooth_status=$(rfkill list bluetooth | grep -i "Soft blocked" | awk '{print $3}')

	if [[ "$wifi_status" == "disabled" && "$bluetooth_status" == "yes" ]]; then
		notify-send -u low "Airplane Mode Deactivated"
		nmcli radio wifi on
		rfkill unblock bluetooth
		printf "%b Airplane Mode Deactivated\n" "$FORMAT_SUCCESS"
	else
		notify-send -u low "Airplane Mode Activated"
		nmcli radio wifi off
		rfkill block bluetooth
		printf "%b Airplane Mode Activated\n" "$FORMAT_SUCCESS"
	fi
}


function main() {
	local actualDate=$(date +"%H:%M  %A  %d/%m/%Y" | tr '[:lower:]' '[:upper:]')
	local actualTheme=$(cat ~/.cache/actual_theme 2>/dev/null || printf "dark")
	
	printf "Initializing settings menu...\n"
	printf "Current theme detected: %s\n" "$actualTheme"

	declare -a menuNames
	declare -a menuCommands

	menuNames[0]="󰖩   Wifi"
	menuNames[1]="   Bluetooth"
	menuNames[2]="󰀝   Airplane Mode"
	menuNames[3]="󰹑   Display"
	menuNames[4]="󰂄   Energy"
	menuNames[5]=$([[ "$actualTheme" == "dark" ]] && printf "   Light Mode" || printf "   Dark Mode")
	menuNames[6]="   Wallpaper"

	menuCommands[0]="sh $SCRIPTS_PATH/wifi_manager.sh"
	menuCommands[1]="blueman-manager"
	menuCommands[2]="toggleAirplaneMode"
	menuCommands[3]="sh $SCRIPTS_PATH/display_manager.sh"
	menuCommands[4]="sh $SCRIPTS_PATH/energy_manager.sh"
	menuCommands[5]="sh $SCRIPTS_PATH/toggle_theme.sh"
	menuCommands[6]="sh $SCRIPTS_PATH/wallpaper_manager.sh"

	local selectedIndex=$(printf "%s\n" "${menuNames[@]}" | rofi -dmenu -i -format i -p "Settings" -mesg "$actualDate" -config $CONFIG_FILE)

	if [[ -z "$selectedIndex" ]]; then
		printf "%b No option selected. Exiting.\n" "$FORMAT_WARNING"
		exit 0
	fi

	local selectedName="${menuNames[$selectedIndex]}"
	local selectedCommand="${menuCommands[$selectedIndex]}"

	printf "Option selected: %s\n" "$selectedName"
	printf "%b Executing command...\n" "$FORMAT_SUCCESS"

	if [[ "$selectedCommand" == "toggleAirplaneMode" ]]; then
		toggleAirplaneMode
		exit 0
	fi

	eval "$selectedCommand"

	return 0
}

main "$@"
