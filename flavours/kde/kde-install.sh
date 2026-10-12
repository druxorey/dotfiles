#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"

declare -r SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
declare -r REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

function main() {
	while getopts "h" opt; do
		case $opt in
			h) printf "\e[1;34mUSAGE:\e[0m %s\n" "${0##*/}" && return 0 ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1 ;;
		esac
	done
	shift $((OPTIND - 1))

	printf "Starting KDE Flavour Installation...\n"

	"$REPO_DIR/cmd/ensure-sudo.sh" || return 1
	"$REPO_DIR/cmd/install-packages.sh" "$SCRIPT_DIR/kde.packages" || return 1
	"$REPO_DIR/cmd/deploy-configs.sh" "$SCRIPT_DIR" || return 1
	"$REPO_DIR/cmd/enable-services.sh" "$SCRIPT_DIR/kde.services" || return 1

	printf "%b KDE flavour installation completed successfully.\n" "$FORMAT_SUCCESS"
	return 0
}

main "$@"
