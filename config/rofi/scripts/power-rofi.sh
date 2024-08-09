#!/bin/bash

runRofi='rofi -dmenu -p -i -config ~/.config/rofi/styles/power-rofi.rasi'

function main() {
    rofiOption=$(echo -e "\n󰤄\n⏻\n" | $runRofi)

    case "$rofiOption" in
    "") dm-tool lock ;;
    "󰤄") bspc quit ;;
    "⏻") systemctl poweroff ;;
    "") systemctl reboot ;;
    *) exit 1 ;;
    esac
}

main $@
