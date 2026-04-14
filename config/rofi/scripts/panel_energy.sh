#!/bin/bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_ERROR="\e[1;31m[ERROR]\e[0m"

declare -r ROFI_CONFIG="$HOME/.config/rofi/modules/panel_energy.rasi"
declare -r PICOM_PATH="$HOME/.config/picom"
declare -r TLP_PATH="/etc"

function checkPicom() {
	if ! pgrep -x "picom" > /dev/null && [[ "$powerPlan" != "performance" ]]; then
		picom -b --config "$PICOM_PATH/picom.conf" &
	fi
}


function main() {
	declare -a displayNames

	displayNames[0]="󱟧   Powersave"
	displayNames[1]="󰥔   Normal"
	displayNames[2]="󱐋   Performance"

	local actualPlan="$(readlink -f "$TLP_PATH/tlp.conf" | cut -c 12)"
	local battery=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)
	local batteryHoursLeft=$(echo "$battery" | grep "time to" | awk '{print $4, $5}')
	local batteryPercentage=$(echo "$battery" | grep "percentage" | awk '{print $2}')

	local message="Battery 0: $batteryPercentage, $batteryHoursLeft remaining"

	case "$actualPlan" in
		"1") selectedPlan=0 ;;
		"2") selectedPlan=2 ;;
		"3") selectedPlan=1 ;;
	esac

	local rofiOption=$(printf "%s\n" "${displayNames[@]}" | rofi -dmenu -m -1 -a "$selectedPlan" -mesg "$message" -config $ROFI_CONFIG)

	local tlpConfigFile="$TLP_PATH/tlp.d/3-normal.conf"
	local powerPlan="normal"
	case "$rofiOption" in
		"${displayNames[0]}")
			tlpConfigFile="$TLP_PATH/tlp.d/1-powersave.conf"
			powerPlan="powersave"
			;;
		"${displayNames[1]}")
			tlpConfigFile="$TLP_PATH/tlp.d/3-normal.conf"
			powerPlan="normal"
			;;
		"${displayNames[2]}")
			tlpConfigFile="$TLP_PATH/tlp.d/2-performance.conf"
			powerPlan="performance"
			;;
		*)
			printf "%b No option selected. Exiting.\n" "${FORMAT_WARNING}"
			exit 0
			;;
	esac

	if [[ -f "$tlpConfigFile" ]]; then
		sudo ln -sf "$tlpConfigFile" "$TLP_PATH/tlp.conf" && printf "Configuration changed to: %s\n" "$(basename $tlpConfigFile)"
		sudo tlp start && printf "%b TLP restarted with the new configuration\n" "$FORMAT_SUCCESS"
		notify-send -u low "Changed energy plan to $powerPlan"
	else
		printf "%b The configuration file '%s' does not exist\n" "$FORMAT_ERROR" "$tlpConfigFile"
		exit 1
	fi

	if [[ "$powerPlan" == "powersave" ]]; then
		checkPicom
		cp "$PICOM_PATH/picom_low_detail.conf" "$PICOM_PATH/picom.conf"
		printf "%b Applied powersave mode\n" "$FORMAT_SUCCESS"
	elif [[ "$powerPlan" == "normal" ]]; then
		checkPicom
		cp "$PICOM_PATH/picom_high_detail.conf" "$PICOM_PATH/picom.conf"
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
