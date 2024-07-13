#!/bin/bash

runRofi='rofi -dmenu -p -i -config ~/.config/rofi/general.rasi'
scriptLocation=~/.config/rofi/scripts

function main() {
    rofiOption=$(echo -e "Network Management\nSystem Control\nApp Search" | $runRofi)

    case "$rofiOption" in
    "Network Management") sh $scriptLocation/wifi-rofi.sh ;;
    "System Control") sh $scriptLocation/power-rofi.sh ;;
    "App Search") rofi -show drun ;;
    *) exit 1 ;;
    esac
}

main $@
