#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"

declare -r TARGET_DIR="$HOME/.local/bin"

function deployUtils() {
	local -r sourceDir="${1%/}"

	if [[ -z $sourceDir || ! -d $sourceDir ]]; then
		printf "%b Utilities directory not found: '%s'\n" "$FORMAT_FAILURE" "$1" >&2
		return 1
	fi

	if ! mkdir -p "$TARGET_DIR" || ! cp -rf "$sourceDir/." "$TARGET_DIR/"; then
		printf "%b Failed to deploy utility scripts to %s\n" "$FORMAT_FAILURE" "$TARGET_DIR" >&2
		return 1
	fi

	# Only touch the files that were deployed, never other binaries in the target
	local file
	for file in "$sourceDir"/*; do
		if [[ -f $file ]]; then
			chmod +x "$TARGET_DIR/${file##*/}" || return 1
		fi
	done

	printf "%b Deployed utility scripts to %s\n" "$FORMAT_SUCCESS" "$TARGET_DIR"
	return 0
}

function main() {
	local opt

	while getopts "h" opt; do
		case $opt in
			h) printf "\e[1;34mUSAGE:\e[0m %s <UTILS_DIR>\n" "${0##*/}" && return 0 ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1 ;;
		esac
	done
	shift $((OPTIND - 1))

	if (($# != 1)); then
		printf "%b Exactly one utilities directory argument is required.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	deployUtils "$1"
}

main "$@"
