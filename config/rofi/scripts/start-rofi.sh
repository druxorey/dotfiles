#!/bin/bash

runRofi='rofi -dmenu -p -i -config ~/.config/rofi/styles/start-rofi.rasi'
scriptLocation=~/.config/rofi/scripts

function main() {
    rofiOption=$(echo -e "\n⏻\n󰀻\n" | $runRofi)

    case "$rofiOption" in
    "") sh $scriptLocation/wifi-rofi.sh ;;
    "⏻") sh $scriptLocation/power-rofi.sh ;;
    "󰀻") rofi -show drun -config ~/.config/rofi/styles/application-rofi.rasi ;;
    "") rofi -show calc -modi calc -no-show-match -no-sort -config ~/.config/rofi/styles/application-rofi.rasi ;;
    *) exit 1 ;;
    esac
}

main $@
