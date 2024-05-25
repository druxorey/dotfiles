#!/bin/bash

XOFF=740
FONT="DejaVu Sans Mono 8"

wifiStatus=$(nmcli -fields WIFI g)

if [[ "$wifiStatus" =~ "enabled" ]]; then
	isWifi="Toggle off"
elif [[ "$wifiStatus" =~ "disabled" ]]; then
	isWifi="Toggle on"
fi

nameWifi=$(echo -e "$isWifi\nSaved connections" | rofi -dmenu -p "SSID: " -xoffset "$XOFF" -font "$FONT")
passwordWifi=$(echo "$nameWifi" | awk -F "," '{print $2}')

if [ "$passwordWifi" = "" ]; then
	nmcli dev wifi con "$nameWifi"
else
	nmcli dev wifi con "$nameWifi" password "$passwordWifi"
fi

if [ "$nameWifi" = "Toggle on" ]; then
	nmcli radio wifi on

elif [ "$nameWifi" = "Toggle off" ]; then
	nmcli radio wifi off

elif [ "$nameWifi" = "Saved connections" ]; then
	savedConnections=$(nmcli -t -f NAME connection show | awk 'NR!=2')
	savedWifiName=$(echo -e "$savedConnections" | rofi -dmenu -p "SSID: " -xoffset "$XOFF" -font "$FONT")
	nmcli dev wifi con "$savedWifiName"
fi
