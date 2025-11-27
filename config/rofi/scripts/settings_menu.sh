#!/bin/bash

SCRIPTS_PATH=~/.config/rofi/scripts

function toggleAirplaneMode() {
	wifi_status=$(nmcli radio wifi)
	bluetooth_status=$(rfkill list bluetooth | grep -i "Soft blocked" | awk '{print $3}')

	if [[ "$wifi_status" == "disabled" && "$bluetooth_status" == "yes" ]]; then
		notify-send -u low "Desactivando Modo Avión"
		nmcli radio wifi on
		rfkill unblock bluetooth
		printf "Airplane Mode Deactivated\n"
	else
		notify-send -u low "Activando Modo Avión"
		nmcli radio wifi off
		rfkill block bluetooth
		printf "Airplane Mode Activated\n"
	fi
}

function main() {
	actualDate=$(date +"%H:%M  %A  %d/%m/%Y" | tr '[:lower:]' '[:upper:]')
	actualTheme=$(cat ~/.cache/actual_theme)
	themeOption="   Light Mode"

	if [[ $actualTheme == "dark" ]]; then
		themeOption="   Light Mode"
	else
		themeOption="   Dark Mode"
	fi

	wifiOption="󰖩   Wifi"
	bluetoothOption="   Bluetooth"
	energyOption="󰂄   Energy"
	airplaneOption="󰀝   Toggle Airplane Mode"
	rofiOption=$(echo -e "$wifiOption\n$bluetoothOption\n$energyOption\n$themeOption\n$airplaneOption" | rofi -dmenu -p -i -m -1 -mesg "$actualDate" -config ~/.config/rofi/modules/settings_menu.rasi)

	case "$rofiOption" in
		"$wifiOption") sh $SCRIPTS_PATH/wifi_manager.sh ;;
		"$bluetoothOption") blueman-manager ;;
		"$energyOption") sh $SCRIPTS_PATH/energy_manager.sh ;;
		"$themeOption") sh $SCRIPTS_PATH/toggle_theme.sh ;;
		"$airplaneOption") toggleAirplaneMode;;
		*) exit 1 ;;
	esac
}

main "$@"
