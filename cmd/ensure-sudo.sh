#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"

function ensureSudo() {
	if [[ $EUID -eq 0 ]]; then
		printf "%b Do not run this script directly as root. Run as a regular user with sudo permissions.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	if ! sudo -v; then
		printf "%b Sudo privileges are required.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	# Keep sudo timestamp updated in background during installation
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
	return 0
}


function main() {
	while getopts "h" opt; do
		case $opt in
			h) printf "\e[1;34mUSAGE:\e[0m %s\n" "${0##*/}" && return 0 ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1 ;;
		esac
	done
	shift $((OPTIND - 1))

	ensureSudo
}

main "$@"
