#!/bin/bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_ERROR="\e[1;31m[ERROR]\e[0m"

function main() {
	while getopts "h" opt; do
		case $opt in
			h) printf "\e[1;34mUSAGE:\e[0m %s INPUT_FILE\n" "$(basename "$0")" && exit 0 ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_ERROR" "$(basename "$0")" >&2 && exit 1 ;;
		esac
	done

	shift $((OPTIND - 1))

	local file="$1"

	[[ -z "$file" ]] && printf "%b No input file provided. Try '%s -h' for more information.\n" "$FORMAT_ERROR" "$(basename "$0")" >&2 && exit 1
	[[ ! -f "$file" ]] && printf "%b File '%s' does not exist.\n" "$FORMAT_ERROR" "$file" >&2 && exit 1

	case "$file" in
		*.tar.bz2) xjf        "$file" ;;
		*.tar.gz)  tar xzf    "$file" ;;
		*.bz2)     bunzip2    "$file" ;;
		*.rar)     unrar x    "$file" ;;
		*.gz)      gunzip     "$file" ;;
		*.tar)     tar xf     "$file" ;;
		*.tbz2)    tar xjf    "$file" ;;
		*.tgz)     tar xzf    "$file" ;;
		*.zip)     7z x       "$file" ;;
		*.Z)       uncompress "$file" ;;
		*.7z)      7z x       "$file" ;;
		*.deb)     ar x       "$file" ;;
		*.tar.xz)  tar xf     "$file" ;;
		*.tar.zst) unzstd     "$file" ;;
		*) printf "%b $file cannot be extracted via ex().\n" "$FORMAT_ERROR" >&2 && exit 1 ;;
	esac

	printf "%b %s extracted successfully.\n" "$FORMAT_SUCCESS" "$file"

	return 0
}

main "$@"
