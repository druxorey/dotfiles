#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"

declare -r TARGET_DIR="$HOME/Documents/A1 Obsidian/D4 Cheatsheets"
declare -r ROFI_CONFIG="$HOME/.config/rofi/shared/layout_find.rasi"

function displayCheatsheet() {
	local filePath="$1"

	if [[ ! -f "$filePath" ]]; then
		printf "%b File not found: '%s'\n" "$FORMAT_FAILURE" "$filePath" >&2
		return 1
	fi

	printf "%b Displaying content for: '%s'\n\n" "$FORMAT_SUCCESS" "${filePath##*/}"
	kitty --class floating_cheatsheets drxcheats "$filePath"
	return 0
}


function main() {
	if [[ ! -d "$TARGET_DIR" ]]; then
		printf "%b Target directory does not exist: '%s'\n" "$FORMAT_FAILURE" "$TARGET_DIR" >&2
		return 1
	fi

	local -a fileNames=()
	local file=""

	for file in "$TARGET_DIR"/*; do
		[[ -f "$file" ]] || continue
		fileNames+=("${file##*/}")
	done

	if ((${#fileNames[@]} == 0)); then
		printf "%b No cheatsheets found in '%s'\n" "$FORMAT_WARNING" "$TARGET_DIR"
		return 0
	fi

	local selectedFile=$(printf "%s\n" "${fileNames[@]}" | rofi -dmenu -i -p "Cheatsheets" -mesg "Select a cheatsheet to view" -config "$ROFI_CONFIG" 2>/dev/null)

	if [[ -z "$selectedFile" ]]; then
		printf "%b No cheatsheet selected. Exiting.\n" "$FORMAT_WARNING"
		return 0
	fi

	displayCheatsheet "$TARGET_DIR/$selectedFile"
}

main "$@"
