#!/bin/bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"

declare -r ROFI_CONFIG="$HOME/.config/rofi/modules/menu_utilities.rasi"
declare -r SCRIPTS_PATH="$HOME/.config/rofi/scripts"

function main() {
	printf "Initializing utilities menu...\n"

	declare -a menuNames
	declare -a menuCommands

	menuNames[0]="   App Launcher"
	menuNames[1]="󰖟   Search in Web"
	menuNames[2]="󰗊   Translator"
	menuNames[3]="󰘎   Text Extraction"

	menuCommands[0]="rofi -show drun -i -config ~/.config/rofi/modules/launcher_apps.rasi"
	menuCommands[1]="sh $SCRIPTS_PATH/panel_search.sh"
	menuCommands[2]="sh $SCRIPTS_PATH/panel_translate.sh"
	menuCommands[3]="sh $SCRIPTS_PATH/toggle_text_extract.sh"

	local selectedIndex=$(printf "%s\n" "${menuNames[@]}" | rofi -dmenu -format i -m -1 -config $ROFI_CONFIG)

	if [[ -z "$selectedIndex" ]]; then
		printf "%b No option selected. Exiting.\n" "$FORMAT_WARNING"
		exit 0
	fi

	local selectedName="${menuNames[$selectedIndex]}"
	local selectedCommand="${menuCommands[$selectedIndex]}"

	printf "Option selected: %s\n" "$selectedName"
	printf "%b Executing command...\n" "$FORMAT_SUCCESS"

	eval "$selectedCommand"

	return 0
}

main "$@"
