#!/bin/bash

CONFIG_DIR="/etc"

function main() {
	rofiOption=$(echo -e "Powersave\nNormal\nPerformance" | rofi -dmenu -p -i -config ~/.config/rofi/styles/energy_styles.rasi)

	case "$rofiOption" in
		"Powersave")
			configFile="$CONFIG_DIR/tlp.d/1-powersave.conf"
			;;
		"Performance")
			configFile="$CONFIG_DIR/tlp.d/2-performance.conf"
			;;
		"Normal")
			configFile="$CONFIG_DIR/tlp.d/3-normal.conf"
			;;
		*)
			echo -e "\e[1;31mERROR: Invalid option"
			exit 1
			;;
	esac

	if [[ -f "$configFile" ]]; then
		sudo ln -sf "$configFile" "$CONFIG_DIR/tlp.conf" && echo "Configuration changed to: $configFile"
		sudo tlp start && echo "TLP restarted with the new configuration"
	else
		echo -e "\e[1;31mERROR: The configuration file '$configFile' does not exist"
		exit 1
	fi
}

main $@
