#!/bin/bash

FORMAT_ERROR="\e[1;31m[ERROR]"
FORMAT_SUCCESS="\e[1;32m[SUCCESS]"
FORMAT_WARNING="\e[1;33m[WARNING]"
FORMAT_END="\e[0m\n"

CONFIG_DIR="/etc"
PICOM_DIR="$HOME/.config/picom"
ACTUAL_PLAN="$(readlink -f "$CONFIG_DIR/tlp.conf" | cut -c 12)"

function main() {
	availablePlans=$(echo -e "󱟧   Powersave\n󰥔   Normal\n󱐋   Performance")

	battery=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)
	batteryHoursLeft=$(echo "$battery" | grep "time to" | awk '{print $4, $5}')
	batteryPercentage=$(echo "$battery" | grep "percentage" | awk '{print $2}')
	message="Battery 0: $batteryPercentage, $batteryHoursLeft remaining"

	case "$ACTUAL_PLAN" in
		"1")
			selectedPlan="-a 0"
			;;
		"2")
			selectedPlan="-a 2"
			;;
		"3")
			selectedPlan="-a 1"
			;;
	esac

	rofiOption=$(echo -e "$availablePlans" | rofi -dmenu -p -i -m -1 $selectedPlan -mesg "$message" -config ~/.config/rofi/modules/energy_manager.rasi | awk '{print $1}')

	case "$rofiOption" in
		"󱟧")
			configFile="$CONFIG_DIR/tlp.d/1-powersave.conf"
			powerPlan="powersave"
			;;
		"󱐋")
			configFile="$CONFIG_DIR/tlp.d/2-performance.conf"
			powerPlan="performance"
			;;
		"󰥔")
			configFile="$CONFIG_DIR/tlp.d/3-normal.conf"
			powerPlan="normal"
			;;
		*)
			printf "${FORMAT_ERROR} Invalid option selected${FORMAT_END}"
			exit 1
			;;
	esac

	if [[ -f "$configFile" ]]; then
		sudo ln -sf "$configFile" "$CONFIG_DIR/tlp.conf" && printf "Configuration changed to: %s ${FORMAT_END}" "$(basename $configFile)"
		sudo tlp start && printf "${FORMAT_SUCCESS} TLP restarted with the new configuration ${FORMAT_END}"
		notify-send -u low "Changed energy plan to $powerPlan"
	else
		printf "${FORMAT_ERROR} The configuration file '%s' does not exist\n" "$configFile"
		exit 1
	fi

	if [[ "$powerPlan" == "powersave" ]]; then
		printf "${FORMAT_WARNING} Killing picom for low-power mode${FORMAT_END}"
		cp "$PICOM_DIR/picom_powersave.conf" "$PICOM_DIR/picom.conf"
	else
		printf "${FORMAT_WARNING} Starting picom for normal/performance mode${FORMAT_END}"
		cp "$PICOM_DIR/picom_performance.conf" "$PICOM_DIR/picom.conf"
	fi
}

main "$@"
