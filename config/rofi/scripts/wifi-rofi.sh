#!/bin/bash

rofiMenu='rofi -dmenu -p -i -config ~/.config/rofi/styles/wifi/wifi-rofi.rasi'
rofiNewSSID='rofi -dmenu -p -i -config ~/.config/rofi/styles/wifi/wifi-newssid.rasi'
rofiNewPassword='rofi -dmenu -p -i -config ~/.config/rofi/styles/wifi/wifi-newpassword.rasi'

function connectToWifi() {
    local nameWifi="$1"
    local passwordWifi="$2"
    local command="nmcli dev wifi con $nameWifi hidden yes"

    [[ -n "$passwordWifi" ]] && command="nmcli dev wifi con $nameWifi password $passwordWifi"

    (
        sleep 15
        kill -15 $$
    ) &

    for ((i = 1; i <= 5; i++)); do
        if $command; then
            break
        fi
        echo "The command failed, retrying..."
        sleep 3
    done
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
		exit
    fi

    nameWifi=$(echo "$rofiOption" | sed 's/^   //' | awk -F ":" '{print $1}')
    passwordWifi=$(echo "$rofiOption" | sed 's/^   //' | awk -F ":" '{print $2}')

    [[ -n $rofiOption ]] && connectToWifi $nameWifi $passwordWifi
}

main $@
