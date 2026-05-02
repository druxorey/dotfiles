#!/bin/bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_ERROR="\e[1;31m[ERROR]\e[0m"

declare -r ROFI_DIR="$HOME/.config/rofi"
declare -r POLYBAR_DIR="$ROFI_DIR/polybar"

declare -r MAIN_ROFI_CONFIG="$ROFI_DIR/modules/panel_wifi.rasi"
declare -r PROMPT_ROFI_CONFIG="$ROFI_DIR/shared/layout_scan.rasi"
declare -r LIST_ROFI_CONFIG="$ROFI_DIR/shared/layout_find.rasi"
declare -r POLYBAR_CONFIG="$POLYBAR_DIR/polybar_panel_wifi.rasi"

declare MONITOR="-m -1"

function connectToWifi() {
	local nameWifi="$1"
	local passwordWifi="$2"
	local command="nmcli dev wifi con \"$nameWifi\" hidden yes"

	if [[ -n "$passwordWifi" ]]; then
		command="nmcli dev wifi con \"$nameWifi\" password \"$passwordWifi\" hidden yes"
	fi

	local notifyId=8000
	local percentage=0
	notify-send "Connecting to $nameWifi..." --app-name "Wifi Manager" -u low -r $notifyId

	for ((i = 1; i <= 5; i++)); do
		percentage=$((i * 20))
		notify-send "Connecting to $nameWifi..." --app-name "Wifi Manager" -u low -r $notifyId -h int:value:${percentage}
		
		if eval "$command" >/dev/null 2>&1; then
			notify-send "Successfully connected to $nameWifi" --app-name "Wifi Manager" -u low -r $notifyId
			printf "%b Connected to: %s\n" "$FORMAT_SUCCESS" "$nameWifi"
			return 0
		fi
		
		printf "%b Attempt %d failed, retrying...\n" "$FORMAT_WARNING" "$i"
		sleep 3
	done

	notify-send "Failed to establish connection" --app-name "Wifi Manager" -u critical
	printf "%b Failed to establish connection to: %s\n" "$FORMAT_ERROR" "$nameWifi"
	return 1
}


function promptSsid() {
	rofi -dmenu -p "SSID" -i $MONITOR -mesg "Enter the SSID of the wifi network to connect" -config "$PROMPT_ROFI_CONFIG"
}


function promptPassword() {
	rofi -dmenu -p "Password" -i $MONITOR -mesg "Enter the password of the wifi network to connect" -config "$PROMPT_ROFI_CONFIG"
}


function addConnection() {
	local nameWifi=$(promptSsid)
	[[ -z "$nameWifi" ]] && return 1

	local passwordWifi=$(promptPassword)
	[[ -z "$passwordWifi" ]] && return 1

	connectToWifi "$nameWifi" "$passwordWifi"
}


function deleteConnection() {
	local nameWifi=$(promptSsid)
	[[ -z "$nameWifi" ]] && return 1

	if nmcli connection delete "$nameWifi" >/dev/null 2>&1; then
		printf "%b Deleted connection: %s\n" "$FORMAT_SUCCESS" "$nameWifi"
		notify-send "Connection deleted" "$nameWifi" --app-name "Wifi Manager" -u low
	else
		printf "%b Failed to delete connection: %s\n" "$FORMAT_ERROR" "$nameWifi"
	fi
}


function savedConnections() {
	local savedSSID=$(nmcli -t -f NAME connection show | awk 'NR!=2 {print "   " $0}')
	local rofiOption=$(echo -e "$savedSSID" | rofi -dmenu -p "Saved" -i $MONITOR -mesg "Select a saved connection" -config "$LIST_ROFI_CONFIG")

	[[ -z "$rofiOption" ]] && return 1

	local nameWifi=$(echo "$rofiOption" | sed 's/^   //' | awk -F ":" '{print $1}')
	local passwordWifi=$(echo "$rofiOption" | sed 's/^   //' | awk -F ":" '{print $2}')

	echo $nameWifi
	echo $passwordWifi

	connectToWifi "$nameWifi" "$passwordWifi"
}


function main() {
	local mainConfig="$MAIN_ROFI_CONFIG"

	if [[ "$1" == "polybar" ]]; then
		MONITOR=""
		mainConfig="$POLYBAR_CONFIG"
	fi

	declare -a menuOptions
	menuOptions[1]="󱛃   Add Connection"
	menuOptions[2]="󱛂   Delete Connection"
	menuOptions[3]="󱛃   Saved Connections"

	local wifiStatus=$(nmcli -fields WIFI g)
	if [[ "$wifiStatus" =~ "enabled" ]]; then
		menuOptions[0]="󰤮   Disable Wi-Fi"
	else
		menuOptions[0]="󰤨   Enable Wi-Fi"
	fi

	local rofiMenu=$(printf "%s\n" "${menuOptions[@]}" | rofi -dmenu -p "Wi-Fi" -i $MONITOR -config "$mainConfig")

	if [[ -z "$rofiMenu" ]]; then
		printf "%b No option selected. Exiting.\n" "$FORMAT_WARNING"
		exit 0
	fi

	nmcli dev wifi rescan >/dev/null 2>&1

	case "$rofiMenu" in
		"${menuOptions[0]}")
			if [[ "${menuOptions[0]}" == *"Enable"* ]]; then
				nmcli radio wifi on && printf "%b Wi-Fi Enabled\n" "$FORMAT_SUCCESS"
			else
				nmcli radio wifi off && printf "%b Wi-Fi Disabled\n" "$FORMAT_SUCCESS"
			fi
			;;
		"${menuOptions[1]}") addConnection ;;
		"${menuOptions[2]}") deleteConnection ;;
		"${menuOptions[3]}") savedConnections ;;
		*)
			printf "%b Invalid option.\n" "$FORMAT_ERROR"
			exit 1
			;;
	esac

	return 0
}

main "$@"
