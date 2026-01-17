#!/bin/bash

CONFIG_PATH="$HOME/.config/rofi/modules/wifi_manager.rasi"
POLYBAR_CONFIG_PATH="$HOME/.config/rofi/polybar/wifi_manager_polybar.rasi"

ROFI_SAVED_PATH='rofi -dmenu -p -i -m -1 -config ~/.config/rofi/widgets/wifi_saved.rasi'
ROFI_SSID_PATH='rofi -dmenu -p -i -m -1 -config ~/.config/rofi/widgets/wifi_newssid.rasi'
ROFI_PASSW_PATH='rofi -dmenu -p -i -m -1 -config ~/.config/rofi/widgets/wifi_newpassword.rasi'

function connectToWifi() {
	local nameWifi="$1"
	local passwordWifi="$2"
	local command="nmcli dev wifi con $nameWifi hidden yes"

	[[ -n "$passwordWifi" ]] && command="nmcli dev wifi con $nameWifi password $passwordWifi hidden yes"

	notify_id=8000
	percentage=0
	notify-send "Connecting to $nameWifi..." --app-name "Wifi Manager" -u low -r $notify_id

	for ((i = 1; i <= 5; i++)); do
		percentage=$((i * 20))
		notify-send "Connecting to $nameWifi..." --app-name "Wifi Manager" -u low -r $notify_id -h int:value:${percentage}
		if $command; then
			notify-send "Successfully connected to $nameWifi" --app-name "Wifi Manager" -u low -r $notify_id 
			return
		fi
		echo "The command failed, retrying..."
		sleep 3
	done

	notify-send "Failed to establish connection" --app-name "Wifi Manager" -u critical
}


function addConnection() {
	nameWifi=$($ROFI_SSID_PATH)
	passwordWifi=$($ROFI_PASSW_PATH)
	[ -z "$nameWifi" ] || [ -z "$passwordWifi" ] && exit

	connectToWifi "$nameWifi" "$passwordWifi"
}


function deleteConnection() {
	nameWifi=$($ROFI_SSID_PATH)
	[ -z "$nameWifi" ] && exit

	nmcli connection delete "$nameWifi"
}


function savedConnections() {
	savedSSID=$(nmcli -t -f NAME connection show | awk 'NR!=2 {print "   " $0}')
	rofiOption=$(echo -e "$savedSSID" | $ROFI_SAVED_PATH)

	nameWifi=$(echo "$rofiOption" | sed 's/^   //' | awk -F ":" '{print $1}')
	passwordWifi=$(echo "$rofiOption" | sed 's/^   //' | awk -F ":" '{print $2}')

	[[ -n $rofiOption ]] && connectToWifi "$nameWifi" "$passwordWifi"
}


function main() {
	addConnectionText="󱛃   Add Connection"
	deleteConnectionText="󱛂   Delete Connection"
	savedConnectionsText="󱛃   Saved Connections"
	disableText="󰤮   Disable Wi-Fi"
	enableText="󰤨   Enable Wi-Fi"

	if [[ $1 == "polybar" ]]; then
		configFile="$POLYBAR_CONFIG_PATH"
		ROFI_SAVED_PATH="rofi -dmenu -p -i $monitor -config ~/.config/rofi/polybar/wifi_saved_polybar.rasi"
		ROFI_SSID_PATH="rofi -dmenu -p -i $monitor -config ~/.config/rofi/polybar/wifi_newssid_polybar.rasi"
		ROFI_PASSW_PATH="rofi -dmenu -p -i $monitor -config ~/.config/rofi/polybar/wifi_newpassword_polybar.rasi"
	else
		configFile="$CONFIG_PATH"
		monitor="-m -1"
	fi

	wifiStatus=$(nmcli -fields WIFI g)

	if [[ "$wifiStatus" =~ "enabled" ]]; then
		isToggled="$disableText"
	elif [[ "$wifiStatus" =~ "disabled" ]]; then
		isToggled="$enableText"
	fi

	rofiOption=$(echo -e "$isToggled\n$addConnectionText\n$deleteConnectionText\n$savedConnectionsText" | rofi -dmenu -p -i $monitor -config "$configFile")

	nmcli dev wifi rescan

	if [ "$rofiOption" = "$enableText" ]; then
		nmcli radio wifi on
		exit
	elif [ "$rofiOption" = "$disableText" ]; then
		nmcli radio wifi off
		exit
	elif [ "$rofiOption" = "$addConnectionText" ]; then
		addConnection
	elif [ "$rofiOption" = "$deleteConnectionText" ]; then
		deleteConnection
	elif [ "$rofiOption" = "$savedConnectionsText" ]; then
		savedConnections
	fi
}

main "$@"
