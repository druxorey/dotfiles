#!/bin/bash

runRofi='rofi -dmenu -p -i -config ~/.config/rofi/styles/start-rofi.rasi'
scriptLocation=~/.config/rofi/scripts

function checkBluetooth() {
	bluetoothctl show | grep -q "Powered: yes"
	echo $?
}


function main() {
	blueStatus=$(checkBluetooth)

	if [[ $blueStatus -eq 0 ]]; then
		bluetoothIcon="󰂯"
		bluetoothCommand='bluetooth off'
	else
		bluetoothIcon="󰂲"
		bluetoothCommand='bluetooth on'
	fi

    rofiOption=$(echo -e "\n󰀻\n$bluetoothIcon\n\n⏻" | $runRofi)

    case "$rofiOption" in
    "") sh $scriptLocation/wifi-rofi.sh ;;
    "󰀻") rofi -show drun -config ~/.config/rofi/styles/application-rofi.rasi ;;
	"$bluetoothIcon") $bluetoothCommand ;;
    "") rofi -show calc -modi calc -no-show-match -no-sort -config ~/.config/rofi/styles/application-rofi.rasi ;;
    "⏻") sh $scriptLocation/power-rofi.sh ;;
    *) exit 1 ;;
    esac
}

main $@
