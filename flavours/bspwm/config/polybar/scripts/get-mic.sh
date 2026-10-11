#!/usr/bin/env bash

function main() {
	local status=$(amixer -D pulse get Capture 2>/dev/null)

	if [[ "$status" != *"[on]"* ]]; then
		printf "\n"
		return
	fi

	case "$1" in
		left)  printf "" ;;
		right) printf "" ;;
		icon)  printf "" ;;
	esac
}

main "$@"
