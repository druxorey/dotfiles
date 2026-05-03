#!/bin/bash

function main() {
	if ! amixer -D pulse get Capture | grep -q '\[on\]'; then
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
