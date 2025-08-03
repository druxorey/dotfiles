#!/bin/bash

CONFIG_DIR="/etc"
ACTUAL_PLAN="$(readlink -f "$CONFIG_DIR/tlp.conf" | cut -c 12)"

function main() {
	case "$ACTUAL_PLAN" in
		"1")
			availablePlans=$(echo -e "󱟧 Powersave      \n󰥔 Normal\n󱐋 Performance")
			;;
		"2")
			availablePlans=$(echo -e "󱟧 Powersave\n󰥔 Normal\n󱐋 Performance   ")
			;;
		"3")
			availablePlans=$(echo -e "󱟧 Powersave\n󰥔 Normal            \n󱐋 Performance")
			;;
	esac

	rofiOption=$(echo -e "$availablePlans" | rofi -dmenu -p -i -config ~/.config/rofi/styles/energy_styles.rasi | awk '{print $1}')

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
			echo -e "\e[1;31mERROR: Invalid option"
			exit 1
			;;
	esac

	if [[ -f "$configFile" ]]; then
		sudo ln -sf "$configFile" "$CONFIG_DIR/tlp.conf" && echo "Configuration changed to: $configFile"
		sudo tlp start && echo "TLP restarted with the new configuration"
		notify-send -u low "Changed energy plan to $powerPlan"
	else
		echo -e "\e[1;31mERROR: The configuration file '$configFile' does not exist"
		exit 1
	fi
}

main $@
