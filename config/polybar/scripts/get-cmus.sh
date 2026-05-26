#!/bin/bash

declare -i MAX_LENGTH_TITLE=50
declare -i MAX_LENGTH_ARTIST=25

function getStatus() {
    if pgrep -x lofi > /dev/null; then
        printf "󰋋   Lofi Radio\n"
        return
    fi

    local status=$(cmus-remote -Q 2>/dev/null)
    if [[ -z $status ]]; then
        printf " \n"
        return
    fi

    local state=$(echo "$status" | sed -n 's/^status //p')
    local artist=$(echo "$status" | sed -n 's/^tag artist //p')
    local title=$(echo "$status" | sed -n 's/^tag title //p')

    [[ ${#title} -gt $MAX_LENGTH_TITLE ]] && title="${title:0:$MAX_LENGTH_TITLE}..."
    [[ ${#artist} -gt $MAX_LENGTH_ARTIST ]] && artist="${artist:0:$MAX_LENGTH_ARTIST}..."

    case "$state" in
        playing) printf "   %s  -  %s\n" "$title" "$artist" ;;
        paused)  printf "   %s  -  %s\n" "$title" "$artist" ;;
        *)       printf "   Stopped\n" ;;
    esac
}

function main() {
    while true; do
        getStatus
        sleep 1
    done
}

main "$@"
