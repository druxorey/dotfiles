#!/bin/bash

ROFI_MENU_PATH='rofi -dmenu -p -i -config ~/.config/rofi/styles/wifi/wifi_menu_styles.rasi'
ROFI_SSID_PATH='rofi -dmenu -p -i -config ~/.config/rofi/styles/wifi/wifi_newssid_styles.rasi'
ROFI_PASSW_PATH='rofi -dmenu -p -i -config ~/.config/rofi/styles/wifi/wifi_newpassword_styles.rasi'

function connectToWifi() {
	local nameWifi="$1"
	local passwordWifi="$2"
	local command="nmcli dev wifi con $nameWifi hidden yes"

	[[ -n "$passwordWifi" ]] && command="nmcli dev wifi con $nameWifi password $passwordWifi hidden yes"

	notify_id=8000
	percentage=0
	notify-send -u low -r $notify_id "Connecting to $nameWifi..."

	for ((i = 1; i <= 5; i++)); do
		percentage=$((i * 20))
		notify-send -u low -r $notify_id -h int:value:${percentage} "Connecting to $nameWifi..."
		if $command; then
			notify-send -u low -r $notify_id "Successfully connected to $nameWifi."
			return
		fi
		echo "The command failed, retrying..."
		sleep 3
	done

	notify-send -u critical "Failed to establish connection"
}

function main() {
	wifiStatus=$(nmcli -fields WIFI g)
	savedConnections=$(nmcli -t -f NAME connection show | awk 'NR!=2 {print "   " $0}')

	if [[ "$wifiStatus" =~ "enabled" ]]; then
		isToggled="󰤮   Disable Wi-Fi"
	elif [[ "$wifiStatus" =~ "disabled" ]]; then
		isToggled="󰤨   Enable Wi-Fi"
	fi

	rofiOption=$(echo -e "󱛃   New Connection\n$isToggled\n$savedConnections" | $ROFI_MENU_PATH)

	if [ "$rofiOption" = "󰤨   Enable Wi-Fi" ]; then
		nmcli radio wifi on
		exit
	elif [ "$rofiOption" = "󰤮   Disable Wi-Fi" ]; then
		nmcli radio wifi off
		exit
	fi

	nmcli dev wifi rescan

	if [ "$rofiOption" = "󱛃   New Connection" ]; then
		nameWifi=$($ROFI_SSID_PATH)
		passwordWifi=$($ROFI_PASSW_PATH)
		[ -z "$nameWifi" ] || [ -z "$passwordWifi" ] && exit
	else
		nameWifi=$(echo "$rofiOption" | sed 's/^   //' | awk -F ":" '{print $1}')
		passwordWifi=$(echo "$rofiOption" | sed 's/^   //' | awk -F ":" '{print $2}')
	fi

	[[ -n $rofiOption ]] && connectToWifi $nameWifi $passwordWifi
}

main $@
