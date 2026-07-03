#!/bin/bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_ERROR="\e[1;31m[ERROR]\e[0m"

declare -r ROFI_CONFIG="$HOME/.config/rofi/modules/panel_energy.rasi"
declare -r PICOM_PATH="$HOME/.config/picom"
declare -r TLP_PATH="/etc"
declare -r CACHE_PLAN="/tmp/power_plan_cache"

function main() {
	declare -a displayNames

	displayNames[0]="󱟧   Powersave"
	displayNames[1]="󰥔   Normal"
	displayNames[2]="󱐋   Performance"
	displayNames[3]="󰺵   Game Mode"

	local battery=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)
	local batteryHoursLeft=$(echo "$battery" | grep "time to" | awk '{print $4, $5}')
	local batteryPercentage=$(echo "$battery" | grep "percentage" | awk '{print $2}')
	local actualPlan="normal"
	if [[ -f "$CACHE_PLAN" ]]; then
		actualPlan=$(cat "$CACHE_PLAN")
	fi

	local message="Battery: $batteryPercentage, $batteryHoursLeft remaining"

	case "$actualPlan" in
		"powersave") selectedPlan=0 ;;
		"normal") selectedPlan=1 ;;
		"performance") selectedPlan=2 ;;
		"game") selectedPlan=3 ;;
		*) selectedPlan=1 ;;
	esac

	local rofiOption=$(printf "%s\n" "${displayNames[@]}" | rofi -dmenu -m -1 -a "$selectedPlan" -mesg "$message" -config $ROFI_CONFIG)

	local tlpConfigFile="$TLP_PATH/tlp.d/01-normal.conf"
	local powerPlan="normal"
	case "$rofiOption" in
		"${displayNames[0]}")
			tlpConfigFile="$TLP_PATH/tlp.d/02-powersave.conf"
			powerPlan="powersave"
			;;
		"${displayNames[1]}")
			tlpConfigFile="$TLP_PATH/tlp.d/01-normal.conf"
			powerPlan="normal"
			;;
		"${displayNames[2]}")
			tlpConfigFile="$TLP_PATH/tlp.d/03-performance.conf"
			powerPlan="performance"
			;;
		"${displayNames[3]}")
			tlpConfigFile="$TLP_PATH/tlp.d/03-performance.conf"
			powerPlan="game"
			;;
		*)
			printf "%b No option selected. Exiting.\n" "${FORMAT_WARNING}"
			exit 0
			;;
	esac

	if [[ -f "$tlpConfigFile" ]]; then
		if sudo ln -sf "$tlpConfigFile" "$TLP_PATH/tlp.conf"; then
			printf "Configuration changed to: %s\n" "$(basename "$tlpConfigFile")"
		else
			printf "%b Failed to change configuration\n" "$FORMAT_ERROR" >&2
			exit 1
		fi

		if sudo tlp start; then
			printf "%b TLP restarted with the new configuration\n" "$FORMAT_SUCCESS"
		else
			printf "%b Failed to restart TLP\n" "$FORMAT_ERROR" >&2
			exit 1
		fi

		notify-send -u low "Changed energy plan to $powerPlan" --app-name "Energy Manager"
		echo "$powerPlan" > "$CACHE_PLAN"
	else
		printf "%b The configuration file '%s' does not exist\n" "$FORMAT_ERROR" "$tlpConfigFile" >&2
		exit 1
	fi

	if [[ "$powerPlan" == "powersave" || "$powerPlan" == "game" ]]; then
		pgrep -x "picom" > /dev/null && pkill picom
	elif [[ "$powerPlan" == "normal" || "$powerPlan" == "performance" ]]; then
		! pgrep -x "picom" > /dev/null && picom -b --config "$PICOM_PATH/picom.conf" &
	fi

	printf "%b Applied %s mode\n" "$FORMAT_SUCCESS" "$powerPlan"

	return 0
}

main "$@"
