#!/bin/bash

SCRIPTS_PATH=~/.config/rofi/scripts
STYLE_PATH='~/.config/rofi/styles/application-rofi.rasi'

function checkBluetooth() {
	bluetoothctl show | grep -q "Powered: yes"
	echo $?
}


function main() {
	runRofi='rofi -dmenu -p -i -config ~/.config/rofi/styles/start-rofi.rasi'
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
    "") sh $SCRIPTS_PATH/wifi-rofi.sh ;;
    "󰀻") rofi -show drun -config $STYLE_PATH;;
	"$bluetoothIcon") $bluetoothCommand ;;
	"") rofi -show calc -modi calc -no-show-match -no-sort -config $STYLE_PATH -calc-command "echo -n '{result}' | xclip -selection clipboard" ;;
    "⏻") sh $SCRIPTS_PATH/power-rofi.sh ;;
    *) exit 1 ;;
    esac
}

main $@
