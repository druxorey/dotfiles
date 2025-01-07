#!/bin/bash

rofiMenu='rofi -dmenu -p -i -config ~/.config/rofi/styles/wifi/wifi-rofi.rasi'
rofiNewSSID='rofi -dmenu -p -i -config ~/.config/rofi/styles/wifi/wifi-newssid.rasi'
rofiNewPassword='rofi -dmenu -p -i -config ~/.config/rofi/styles/wifi/wifi-newpassword.rasi'

function connectToWifi() {
    local nameWifi="$1"
    local passwordWifi="$2"
    local command="nmcli dev wifi con $nameWifi hidden yes"

    [[ -n "$passwordWifi" ]] && command="nmcli dev wifi con $nameWifi password $passwordWifi hidden yes"

    for ((i = 1; i <= 5; i++)); do
        if $command; then
			notify-send -u low "Successfully connected to the WiFi network '$nameWifi'."
			exit
        fi
        echo "The command failed, retrying..."
        sleep 3
    done

	notify-send -u critical "Failed to establish connection. Please check the WiFi name and password."
}

function main() {
    wifiStatus=$(nmcli -fields WIFI g)
    savedConnections=$(nmcli -t -f NAME connection show | awk 'NR!=2 {print "   " $0}')

    if [[ "$wifiStatus" =~ "enabled" ]]; then
        isToggled="󰤮   Disable Wi-Fi"
    elif [[ "$wifiStatus" =~ "disabled" ]]; then
        isToggled="󰤨   Enable Wi-Fi"
    fi

    rofiOption=$(echo -e "󱛃   New Connection\n$isToggled\n$savedConnections" | $rofiMenu)

    if [ "$rofiOption" = "󰤨   Enable Wi-Fi" ]; then
        nmcli radio wifi on
        exit
    elif [ "$rofiOption" = "󰤮   Disable Wi-Fi" ]; then
        nmcli radio wifi off
        exit
    fi

    if [ "$rofiOption" = "󱛃   New Connection" ]; then
        nameWifi=$($rofiNewSSID)
        passwordWifi=$($rofiNewPassword)

		if [ -z "$nameWifi" ] || [ -z "$passwordWifi" ]; then
			exit
		fi
	else
		nameWifi=$(echo "$rofiOption" | sed 's/^   //' | awk -F ":" '{print $1}')
		passwordWifi=$(echo "$rofiOption" | sed 's/^   //' | awk -F ":" '{print $2}')
    fi

    [[ -n $rofiOption ]] && connectToWifi $nameWifi $passwordWifi
}

main $@
