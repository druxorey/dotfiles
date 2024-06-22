#!/bin/bash

runRofi='rofi -dmenu -p "Direct Connection: " -config ~/.config/rofi/power.rasi'


function main() {
    rofiOption=$(echo -e "Lock\nLog Out\nShutdown\nReboot" | $runRofi)

    case "$rofiOption" in
        "Lock") dm-tool lock ;;
        "Log Out") bspc quit ;;
        "Shutdown") systemctl poweroff ;;
        "Reboot") systemctl reboot ;;
        *) exit 1 ;;
    esac
}

main $@
