#!/bin/bash

SCRIPTS_PATH=~/.config/rofi/scripts
STYLE_PATH='~/.config/rofi/styles/application-rofi.rasi'

function main() {
	runRofi='rofi -dmenu -p -i -config ~/.config/rofi/styles/start-rofi.rasi'
    rofiOption=$(echo -e "\n󰀻\n󰂄\n⏻" | $runRofi)

    case "$rofiOption" in
    "") sh $SCRIPTS_PATH/wifi-rofi.sh ;;
    "󰀻") rofi -show drun -config $STYLE_PATH;;
	"󰂄") sh $SCRIPTS_PATH/powerplan-rofi.sh ;;
    "⏻") sh $SCRIPTS_PATH/power-rofi.sh ;;
    *) exit 1 ;;
    esac
}

main $@
