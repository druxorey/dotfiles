#!/bin/bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_ERROR="\e[1;31m[ERROR]\e[0m"

declare -r CONFIG_FILE="$HOME/.config/rofi/modules/energy_manager.rasi"
declare -r TLP_DIR="/etc"
declare -r PICOM_DIR="$HOME/.config/picom"

function checkPicom() {
	if ! pgrep -x "picom" > /dev/null && [[ "$powerPlan" != "performance" ]]; then
		picom -b --config "$PICOM_DIR/picom.conf" &
	fi
}


function main() {
	local availablePlans="󱟧   Powersave\n󰥔   Normal\n󱐋   Performance"
	local actualPlan="$(readlink -f "$TLP_DIR/tlp.conf" | cut -c 12)"
	local battery=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)
	local batteryHoursLeft=$(echo "$battery" | grep "time to" | awk '{print $4, $5}')
	local batteryPercentage=$(echo "$battery" | grep "percentage" | awk '{print $2}')

	local message="Battery 0: $batteryPercentage, $batteryHoursLeft remaining"

	case "$actualPlan" in
		"1") selectedPlan=0 ;;
		"2") selectedPlan=2 ;;
		"3") selectedPlan=1 ;;
	esac

	local rofiOption=$(echo -e "$availablePlans" | rofi -dmenu -p -i -m -1 -a "$selectedPlan" -mesg "$message" -selected-row "$selectedPlan" -config $CONFIG_FILE | awk '{print $1}')

	local configFile="$TLP_DIR/tlp.d/3-normal.conf"
	local powerPlan="normal"
	case "$rofiOption" in
		"󱟧")
			configFile="$TLP_DIR/tlp.d/1-powersave.conf"
			powerPlan="powersave"
			;;
		"󱐋")
			configFile="$TLP_DIR/tlp.d/2-performance.conf"
			powerPlan="performance"
			;;
		"󰥔")
			configFile="$TLP_DIR/tlp.d/3-normal.conf"
			powerPlan="normal"
			;;
		*)
			printf "%b No option selected. Exiting.\n" "${FORMAT_WARNING}"
			exit 0
			;;
	esac

	if [[ -f "$configFile" ]]; then
		sudo ln -sf "$configFile" "$TLP_DIR/tlp.conf" && printf "Configuration changed to: %s\n" "$(basename $configFile)"
		sudo tlp start && printf "%b TLP restarted with the new configuration\n" "$FORMAT_SUCCESS"
		notify-send -u low "Changed energy plan to $powerPlan"
	else
		printf "%b The configuration file '%s' does not exist\n" "$FORMAT_ERROR" "$configFile"
		exit 1
	fi

	if [[ "$powerPlan" == "powersave" ]]; then
		checkPicom
		cp "$PICOM_DIR/picom_low_detail.conf" "$PICOM_DIR/picom.conf"
		printf "%b Applied powersave mode\n" "$FORMAT_SUCCESS"
	elif [[ "$powerPlan" == "normal" ]]; then
		checkPicom
		cp "$PICOM_DIR/picom_high_detail.conf" "$PICOM_DIR/picom.conf"
		printf "%b Applied normal mode\n" "$FORMAT_SUCCESS"
	elif [[ "$powerPlan" == "performance" ]]; then
		if pgrep -x "picom" > /dev/null; then
			pkill picom
		fi
		printf "%b Applied performance mode\n" "$FORMAT_SUCCESS"
	fi

	return 0
}

main "$@"
