#!/bin/bash

declare -r FORMAT_ERROR="\e[1;31m[ERROR]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"

declare -r ROFI_CONFIG="$HOME/.config/rofi/modules/panel_shortcuts.rasi"
declare -r PARSER_SCRIPT="$HOME/.config/rofi/utilities/get_shortcuts.py"
declare -r SXHKD_CONFIG="$HOME/.config/sxhkd/sxhkdrc"

function main() {
	[[ ! $1 == "polybar" ]] && monitor="-m -1"

	if [[ ! -f "$PARSER_SCRIPT" ]]; then
		printf "%b Shortcuts parser script not found at: $PARSER_SCRIPT" "$FORMAT_ERROR" >&2
		exit 1
	fi

	local shortcutList=$(python3 "$PARSER_SCRIPT" "$SXHKD_CONFIG" 2>/dev/null)

	if [[ -z "$shortcutList" ]]; then
		printf "%b No shortcuts found or parser error." "$FORMAT_WARNING" >&2
		exit 1
	fi

	echo -e "$shortcutList" | rofi -dmenu $monitor -markup-rows -i -p "  Shortcuts" -config "$ROFI_CONFIG" >/dev/null

	return 0
}

main "$@"
